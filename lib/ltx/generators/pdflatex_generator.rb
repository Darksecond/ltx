require 'ltx'

module Ltx::Generators
	class PdflatexGenerator
		include Ltx::Log

		def self.maybe?(document, options={})
			new document, options
		end

		def initialize(document, options={})
			raise "document can't be nil" if document.nil?
			@document = document
			@modules = find_modules
		end
		
		def generate
			info self, "Starting"
			current_step = Step.new @document, {modules: @modules}

			current_step.begin

			while current_step.rerun?
				#warn or error or fatal here?
				raise "generation got too large: #{current_step.generation}" if current_step.generation > 10
				current_step = current_step.next_step
			end

			current_step.end
			info self, "Finished"
			current_step
		end

		private

		def find_modules
			[
			Ltx::Modules::MakeglossariesModule.maybe?(@document),
			Ltx::Modules::BiberModule.maybe?(@document)
			]
		end
	end
end
