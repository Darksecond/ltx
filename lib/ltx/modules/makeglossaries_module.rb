require 'ltx'

module Ltx::Modules
	class MakeglossariesModule
		include Ltx::Log

		def self.maybe?(document)
			if document.glossary?
				new document
			else
				nil
			end
		end

		def initialize(document)
			@document = document
		end

		def begin_chain(step)
			step.track_file(@document.primary.file("glo", true))
		end

		def post_compile(step)
			gloss = Ltx::Commands::MakeglossariesCommand.new(@document.primary)
			gloss.execute
			info self, "Executing makeglossaries"

			step.rerun
		end

		def needs_run?(step)
			if not @document.primary.file("gls", true).exists?
				return true
			end

			#fix this up massively
			if step.get_file_tracker(@document.primary.file("glo")).changed?
				return true
			end

			return false

		end
	end
end
