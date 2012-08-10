require 'ltx'

module Ltx::Generators
	class PdflatexGenerator
		include Ltx::Log

		def initialize(document)
			@document = document
			@modules = [
				Ltx::Modules::MakeglossariesModule.new(document), 
				Ltx::Modules::BiberModule.new(document, [@document.primary.file("bib",true)])
			]
		end
		
		def generate
			log! self, "Starting"
			current_step = Step.new @document, {modules: @modules}

			current_step.begin

			while current_step.rerun?
				raise "generation got too large: #{current_step.generation}" if current_step.generation > 10
				current_step = current_step.next_step
			end

			current_step.end
			log! self, current_step.full_log
			log! self, "Finished"
			current_step
		end
	end
end
