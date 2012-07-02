require 'ltx'
require 'open3'

module Ltx::Commands
	class BiberCommand
		BIBER_COMMAND = "biber"

		def initialize(source)
			@source = source
		end

		def source
			@source
		end

		def execute
			arguments = build_arguments

			Open3.popen3(BIBER_COMMAND, *arguments) do |stdin, stdout, stderr, wait_thr|
				wait_thr.value
			end

			@source.rescan
		end

		private

		def build_arguments
			arguments = []
			arguments << "--quiet"
			arguments << @source.base
			arguments
		end
		
	end
end
