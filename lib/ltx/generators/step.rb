require 'ltx'

module Ltx::Generators
	class Step
		def self.create_from_step(original)
			step = Step.new(original.document, 
					modules: original.modules, 
					rerun: original.rerun?, 
					generation: (original.generation + 1),
					previous: original,
					trackers: original.trackers.clone
				       )
		end

		def initialize(document, options={})
			options = {generation: 0, rerun: true, previous: nil, trackers: []}.merge(options)
			@trackers = options.fetch :trackers
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
			latex = Ltx::Commands::PdflatexCommand.new(@document)
			latex.execute
			@rerun = latex.rerun_needed?
			#retrack files
			update_trackers
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

		def trackers
			@trackers
		end

		def track_file(source)
			#build in duplication detection
			@trackers << Ltx::FileTracker.new(source)
		end

		def track_ext(ext)
			@trackers << Ltx::ExtensionTracker.new(ext, document)
		end
		
		def get_file_tracker(source)
			@trackers.select { |tracker|
				tracker.class == Ltx::FileTracker && tracker.source == source
			}.first
		end

		def get_ext_tracker(ext)
			@trackers.select { |tracker|
				tracker.class == Ltx::ExtensionTracker && tracker.extension == ext
			}.first
		end

		private

		def update_trackers
			@trackers.map! do |tracker|
				tracker.update
			end
		end

		def init_modules
			@modules.each do |mod|
				mod.start_chain(self)
			end
		end
	end
end
