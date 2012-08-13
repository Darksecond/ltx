require 'ltx'

module Ltx::Generators
	class Step
		include Ltx::Log

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
			options = {generation: 0, rerun: true, previous: nil, trackers: [], modules: []}.merge(options)
			@trackers = options.fetch :trackers
			@previous = options.fetch :previous
			@generation = options.fetch :generation
			@rerun = options.fetch :rerun
			@modules = options.fetch :modules
			@document = document

			info self, "Step, generation: #{@generation}"
		end

		def begin
			@modules.each do |mod|
				mod.begin_chain(self)
			end
			info self, "Running Begin chain on all modules"
		end

		def end
			@modules.each do |mod|
				if mod.respond_to? :end_chain
					mod.end_chain(self)
				end
			end
			info self, "Running end chain on all modules"
		end

		def next_step
			#run pdflatex_command
			#TODO move this into a (special case) module?
			latex = Ltx::Commands::PdflatexCommand.new(@document)
			latex.execute
			info self, "Executing Pdflatex"
			@rerun = latex.rerun_needed?
			#retrack files
			update_trackers
			#run modules
			@modules.each do |mod|
				if mod.needs_run? self
					mod.post_compile self
				end
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
	end
end
