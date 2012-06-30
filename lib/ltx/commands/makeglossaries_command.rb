require 'open3'

module Ltx::Commands
	class MakeglossariesCommand
		MAKEGLOSSARIES_COMMAND = "makeglossaries"

		def initialize(document)
			raise "no document specified" unless document
			#check if document exists

			@document = document
		end

		def document
			@document
		end

		def execute

			#build command line
			arguments = build_arguments
			#run pdflatex command
			Open3.popen3(MAKEGLOSSARIES_COMMAND, *arguments) do |stdin, stdout, stderr, wait_thr|
				wait_thr.value
			end
		end

		private

		def build_arguments
			arguments = []
			arguments << "-q"
			arguments << @document
			arguments
		end
	end
end
