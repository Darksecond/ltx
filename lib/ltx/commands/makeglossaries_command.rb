require 'open3'

module Ltx::Commands
	class MakeglossariesCommand
		MAKEGLOSSARIES_COMMAND = "makeglossaries"

		def initialize(source)
			raise "no source specified" unless source

			@source = source
		end

		def source
			@source
		end

		def execute

			#build command line
			arguments = build_arguments
			#run pdflatex command
			Open3.popen3(MAKEGLOSSARIES_COMMAND, *arguments) do |stdin, stdout, stderr, wait_thr|
				wait_thr.value
			end

			@source.rescan
		end

		private

		def build_arguments
			arguments = []
			arguments << "-q"
			arguments << @source.base
			arguments
		end
	end
end
