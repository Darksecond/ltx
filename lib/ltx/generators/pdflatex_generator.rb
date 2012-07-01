require 'ltx/generators/step'
require 'ltx/modules/makeglossaries_module'
require 'ltx/modules/biber_module'

module Ltx::Generators
	class PdflatexGenerator
		def initialize(document)
			@document = document
			@modules = [
				Ltx::Modules::MakeglossariesModule.new(document), 
				Ltx::Modules::BiberModule.new(document, [@document.primary.secondary("bib",true)])
			]
		end
		
		def generate
			#current_step = generate step
			#while current_step.rerun?
			#current_step = current_step.next_step
			current_step = Step.new @document, {modules: @modules}

			while current_step.rerun?
				raise "generation got too large: #{current_step.generation}" if current_step.generation > 10
				current_step = current_step.next_step
			end

			current_step
		end
	end
end
