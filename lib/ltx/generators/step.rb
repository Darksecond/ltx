require 'ltx/commands/pdflatex_command'

module Ltx::Generators
	class Step
		def initialize(document, previous = nil, modules = nil)
			@previous = previous
			if previous
				@generation = previous.generation + 1

				#we need this to mirror the previous state
				@rerun = previous.rerun?
				@modules = previous.modules
			else
				@generation = 0
				@rerun = true
				@modules = modules
			end
			@document = document
			#hash?
		end

		def next_step
			#run pdflatex_command
			latex = Ltx::Commands::PdflatexCommand.new(@document)
			latex.execute
			@rerun = latex.rerun_needed?
			#retrack files
			#...
			#run modules
			@modules.each do |module|
				module.post_compile(self)
			end
			#return new step
			Step.new(@document, self)
		end

		def rerun?
			@rerun
		end

		def rerun
			@rerun = true
		end

		def generation
			@generation
		end

		#track...
		def track(file)
			#add track
			#update track
		end

		def get_track(file)
			@tracks[file.to_sym]
		end

		private

		def update_track(file)
		end
	end
end
