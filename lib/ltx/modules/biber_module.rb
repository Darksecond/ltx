require 'ltx/commands/biber_command'

module Ltx::Modules
	class BiberModule
		def initialize(document)
			@document = document
		end

		def start_chain(step)
			step.track_ext "aux"
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
			#aux changed between compile, rerun
			if step.get_ext_tracker("aux").changed?
				return true
			end

			#doc.primary.blg does not exist, rerun
			unless @document.primary.secondary("blg").exists?
				return true
			end

			#doc.primary.blg is older than doc.primary.log, rerun
			blg = @document.primary.secondary("blg")
			log = @document.primary.secondary("log")
			if blg < log
				return true
			end
			#
			#parse aux
			#...
		end

		def changed?(step, sourcefile)
			current = step.get_track sourcefile
			previous = step.previous.get_track sourcefile if step.previous

			if current != previous
				return true
			end
		end
	end
end
