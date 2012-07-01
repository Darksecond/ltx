require 'ltx/commands/makeglossaries_command'

module Ltx::Modules
	class MakeglossariesModule
		def initialize(document)
			@document = document
		end

		def start_chain(step)
			#track glo
			#fix this up massively
			step.track_file(@document.primary.secondary("glo", true))
		end

		def post_compile(step)
			#fix this up massively
			if needs_run?(step)
				gloss = Ltx::Commands::MakeglossariesCommand.new(@document.primary)
				gloss.execute

				step.rerun
			end
		end

		private

		def needs_run?(step)
			if not @document.primary.secondary("gls", true).exists?
				return true
			end

			#fix this up massively
			if step.get_file_tracker(@document.primary.secondary("glo")).changed?
				return true
			end

			return false

		end
	end
end
