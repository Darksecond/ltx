require 'open3'

module Ltx::Commands
	class BiberCommand
		BIBER_COMMAND = "biber"

		def initialize(document)
			@document = document
		end

		def document
			@document
		end

		def execute
			arguments = build_arguments

			Open3.popen3(BIBER_COMMAND, *arguments) do |stdin, stdout, stderr, wait_thr|
				wait_thr.value
			end

			@document.rescan
		end

		private

		def build_arguments
			arguments = []
			arguments << "--quiet"
			arguments << @document.primary.base
			arguments
		end
		
	end
end
