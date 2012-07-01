require 'ltx/commands/biber_command'

module Ltx::Modules
	class BiberModule
		def initialize(document, bibs)
			@document = document
			@bibs = bibs

			@citations = []
			@dbs = []
			@undefs = []
			@needs_run = false
		end

		def start_chain(step)
			step.track_ext "aux"

			#bibs changed since last compile
			pdf = @document.primary.secondary("pdf",true)
			@bibs.each do |bib|
				if bib.mtime > pdf.mtime
					@needs_run = true
				end
			end
		end

		def post_compile(step)
			if needs_run?(step)
				cmd = Ltx::Commands::BiberCommand.new(@document)
				cmd.execute

				step.rerun
			end
		end

		private

		def needs_run?(step)
			if @needs_run
				@needs_run = false
				return true
			end

			#aux changed between compile, rerun
			if step.get_ext_tracker("aux").changed?
				return true
			end
			
			#parse aux
			citations, dbs = parse_aux
			undefs = parse_log
			if @dbs != dbs
				@dbs = dbs
				@citations = citations
				@undefs = undefs
				return true
			end

			if @citations != citations
				@citations = citations
				@undefs = undefs
				return true
			end

			diff = undefs - @undefs
			unless diff.empty?
				#there are new undefs
				@undefs = undefs
				return true
			end
			@undefs = undefs

			#doc.primary.blg does not exist, rerun
			unless @document.primary.secondary("blg").exists?
				return true
			end

			if @undefs.empty?
				return false
			end

			#doc.primary.blg is older than doc.primary.log, rerun
			blg = @document.primary.secondary("blg").mtime
			log = @document.primary.secondary("log").mtime
			if blg < log
				return true
			end

			return false
		end

		def parse_aux
			citations = []
			dbs = []
			files = @document.find_by_type "aux"
			files.each do |file|
				File.open(file.to_s) do |aux|
					until aux.eof?
						line = aux.readline.strip!
						match = /\\citation{(?<cite>.*)}/.match(line)
						if match
							citations << match[:cite]
						end
						match = /\\bibdata{(?<data>.*)}/.match(line)
						if match
							dbs += match[:data].split(",")
						end
					end
				end
			end
			[citations, dbs]
		end

		def parse_log
			undefs = []
			log = @document.primary.secondary("log")
			if log.exists?
				File.open(log.to_s) do |log|
					until log.eof?
						line = log.readline.strip!
						match = /LaTeX Warning: Citation `(?<cite>.*)' .*undefined.*/.match(line)
						if match
							undefs << match[:cite]
						end
					end
				end
			end
			undefs
		end
	end
end
