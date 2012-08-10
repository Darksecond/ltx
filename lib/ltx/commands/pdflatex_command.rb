require 'ltx'
require 'open3'

module Ltx::Commands
	class PdflatexCommand
		PDFLATEX_COMMAND = "pdflatex"

		def initialize(document)
			raise "no document specified" unless document

			@document = document
			@draft = false
		end

		def draft
			@draft = !@draft
		end

		def draft?
			@draft
		end

		def draft=(draft)
			@draft = draft
		end

		def document
			@document
		end

		def execute

			#build command line
			arguments = build_arguments
			#run pdflatex command
			Open3.popen3(PDFLATEX_COMMAND, *arguments) do |stdin, stdout, stderr, wait_thr|
				wait_thr.value
			end

			@document.rescan

		end

		#...log parsing here...
		#log_rerun?
		#etc
		
		def rerun_needed?
			@document.primary.file("log", true).rerun_needed?
		end

		private

		def build_arguments
			arguments = []
			arguments << "-draftmode" if @draft
			arguments << "-interaction=batchmode"
			arguments << @document.primary.base
			arguments
		end
	end
end
