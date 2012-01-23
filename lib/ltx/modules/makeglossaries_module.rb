require 'ltx/commands/makeglossaries_command'

module Ltx::Modules
	class MakeglossariesModule
		def initialize(document)
			@document = document
		end

		def start_chain(step)
			#track glo
			#fix this up massively
			step.track("#{@document}.glo")
		end

		def post_compile(step)
			#fix this up massively
			if needs_run?(step)
				gloss = Ltx::Commands::MakeglossariesCommand.new(@document)
				gloss.execute
			end
		end

		private

		def needs_run?(step)
			if not File.exists? "#{@document}.gls"
				return true
			end

			#fix this up massively
			current = step.get_track("#{@document}.glo")
			current = current[:checksum] if current
			previous = step.previous.get_track("#{@document}.glo") if step.previous
			previous = previous[:checksum] if previous
			if current != previous
				return true
			end

			return false

		end
	end
end
