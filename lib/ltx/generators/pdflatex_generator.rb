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
				#TODO warn or error or fatal here?
				raise "generation got too large: #{current_step.generation}" if current_step.generation > 10
				current_step = current_step.next_step
			end

			current_step.end
			info self, "Finished"
			current_step
		end

		def clean(full=false)
			#TODO delegate to modules instead!
			queue = [
			@document.find_by_type("aux"),
			@document.find_by_type("bbl"),
			@document.find_by_type("bcf"),
			@document.find_by_type("blg"),
			@document.find_by_type("glg"),
			@document.find_by_type("glo"),
			@document.find_by_type("gls"),
			@document.find_by_type("log"),
			@document.find_by_type("run.xml"),
			@document.find_by_type("xdy")
			].flatten

			queue << @document.primary.file("pdf") if full
			queue.compact.each &:destroy!
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
