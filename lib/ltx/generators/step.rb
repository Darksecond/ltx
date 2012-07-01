require 'ltx/commands/pdflatex_command'

module Ltx::Generators
	class Step
		def self.create_from_step(original)
			step = Step.new(original.document, 
					modules: original.modules, 
					rerun: original.rerun?, 
					generation: (original.generation + 1),
					previous: original
				       )
		end

		def initialize(document, options={})
			options = {generation: 0, rerun: true, previous: nil}.merge(options)
			@tracks = {}
			@previous = options.fetch :previous
			@generation = options.fetch :generation
			@rerun = options.fetch :rerun
			@modules = options.fetch :modules
			@document = document

			#init modules
			#this should probably go somewhere else...
			if @generation == 0
				init_modules
			end
		end

		def next_step
			#run pdflatex_command
			latex = Ltx::Commands::PdflatexCommand.new(@document.primary)
			latex.execute
			@rerun = latex.rerun_needed?
			#retrack files
			update_tracks
			#run modules
			@modules.each do |mod|
				mod.post_compile(self)
			end
			#return new step
			Step.create_from_step(self)
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

		def document
			@document
		end

		def previous
			@previous
		end

		def modules
			@modules
		end

		#replace hash with actual class
		def track(file)
			@tracks[file] = file.checksum
		end

		def get_track(file)
			@tracks[file]
		end

		private

		def update_tracks
			@tracks.each do |key, _|
				track(key)
			end
		end

		def init_modules
			@modules.each do |mod|
				mod.start_chain(self)
			end
		end
	end
end
