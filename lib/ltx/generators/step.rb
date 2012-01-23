require 'ltx/commands/pdflatex_command'
require 'digest/md5'

module Ltx::Generators
	class Step
		def initialize(document, previous = nil, modules = nil)
			@tracks = {}
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

			#init modules
			#this should probably go somewhere else...
			if @generation == 0
				@modules.each do |mod|
					mod.start_chain(self)
				end
			end
		end

		def next_step
			#run pdflatex_command
			latex = Ltx::Commands::PdflatexCommand.new(@document)
			latex.execute
			@rerun = latex.rerun_needed?
			#retrack files
			update_tracks
			#run modules
			@modules.each do |mod|
				mod.post_compile(self)
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

		def previous
			@previous
		end

		def modules
			@modules
		end

		#replace hash with actual class
		def track(file)
			#add track
			@tracks[file.to_sym] = {file: file}
			#update track
			update_track(file)
		end

		def get_track(file)
			@tracks[file.to_sym]
		end

		private

		def update_track(file)
			t = get_track(file)
			begin
				t[:checksum] = Digest::MD5.file(t[:file]).to_s
			rescue
			end
			@tracks[file.to_sym] = t
		end

		def update_tracks
			@tracks.each do |key, value|
				update_track(value[:file])
			end
		end
	end
end
