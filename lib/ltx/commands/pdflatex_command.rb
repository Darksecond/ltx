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

			#parse log
			parse_log read_log
		end

		#...log parsing here...
		#log_rerun?
		#etc
		
		def rerun_needed?
			@rerun_needed
		end

		private

		def build_arguments
			arguments = []
			arguments << "-draftmode" if @draft
			arguments << "-interaction=batchmode"
			arguments << @document.primary.base
			arguments
		end

		def read_log
			lines = []
			prev = ""
			File.open(@document.primary.file("log").to_s) do |file|
				until file.eof?
					line = file.readline.strip!
					if line.length == 79
						prev += line
					elsif line.length == 0
						lines << prev if prev != ""
						prev = ""
					else
						prev += line
						lines << prev
						prev = ""
					end
				end
			end
			lines
		end

		def parse_log(lines)
			lines.each do |line|
				if (line =~ /LaTeX Warning:.*Rerun/) != nil
					@rerun_needed = true
				#elsif
				end
			end
		end
	end
end
