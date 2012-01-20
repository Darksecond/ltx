require 'ltx/generators/step'
require 'ltx/modules/makeglossaries_module'

module Ltx::Generators
	class PdflatexGenerator
		def initialize(document)
			@document = document
			@modules = [Ltx::Modules::MakeglossariesModule.new]
		end
		
		def generate
			#current_step = generate step
			#while current_step.rerun?
			#current_step = current_step.next_step
			current_step = Step.new(@document,nil,@modules)

			while current_step.rerun?
				throw "generation got too large: #{current_step.generation}" if current_step.generation > 10
				current_step = current_step.next_step
			end

			current_step
		end
	end
end
