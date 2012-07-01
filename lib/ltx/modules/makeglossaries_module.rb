require 'ltx/commands/makeglossaries_command'

module Ltx::Modules
	class MakeglossariesModule
		def initialize(document)
			@document = document
		end

		def start_chain(step)
			#track glo
			#fix this up massively
			step.track(@document.primary.secondary("glo", true))
		end

		def post_compile(step)
			#fix this up massively
			if needs_run?(step)
				gloss = Ltx::Commands::MakeglossariesCommand.new(@document.primary)
				gloss.execute
			end
		end

		private

		def needs_run?(step)
			if not @document.primary.secondary("gls", true).exists?
				return true
			end

			#fix this up massively
			current = step.get_track(@document.primary.secondary("glo"))
			previous = step.previous.get_track(@document.primary.secondary("glo")) if step.previous
			
			#TODO what about current and previous both being nil?
			
			if current != previous
				return true
			end

			return false

		end
	end
end
