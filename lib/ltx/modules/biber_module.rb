require 'ltx'

module Ltx::Modules
	class BiberModule
		include Ltx::Log

		def self.maybe?(document)
			if document.bibliography?
				new document, document.bibliographies
			else
				nil
			end
		end

		def initialize(document, bibs)
			@document = document
			@bibs = bibs

			@citations = []
			@dbs = []
			@undefs = []
			@needs_run = false
		end

		def begin_chain(step)
			step.track_ext "aux"

			#bibs changed since last compile
			pdf = @document.primary.file("pdf",true)
			@bibs.each do |bib|
				if pdf.exists? && bib.mtime > pdf.mtime
					@needs_run = true
				end
			end
			unless pdf.exists? #does this belong here? or in needs_run?
				@needs_run = true
			end
		end

		def post_compile(step)
			cmd = Ltx::Commands::BiberCommand.new(@document.primary)
			cmd.execute
			info "Executing Biber"

			step.rerun
		end

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
			undefs = @document.primary.file("log", true).undefined_citations
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
			unless @document.primary.file("blg",true).exists?
				return true
			end

			if @undefs.empty?
				return false
			end

			#doc.primary.blg is older than doc.primary.log, rerun
			blg = @document.primary.file("blg").mtime
			log = @document.primary.file("log").mtime
			if blg < log
				return true
			end

			return false
		end

		private

		def parse_aux
			citations = []
			dbs = []
			files = @document.find_by_type("aux").each do |file|
				citations += file.used_citations
				dbs += file.databases
			end
			[citations, dbs]
		end
	end
end
