require 'ltx'

module Ltx
	class SourceDirectory
		def initialize(document, type, options={})
			options = {manual: false}.merge(options)
			@document = document
			@type = type
			@manual = options.fetch :manual

			@sources = if @manual
					  []
				  else
					  find_sources
				  end
		end

		def rescan
			if @manual
				@sources.each do |source|
					source.rescan
				end
			else
				@sources = find_sources
			end
		end

		def sources
			@sources
		end

		def find_by_type(type)
			sources.map { |sec| sec.file(type, false) }.compact
		end

		def include(source)
			@sources << Source.new(source.to_s, type: @type)
		end
		
		def type
			@type
		end

		def to_s
			type
		end

		private

		def find_sources
			glob = File.join(@document.basedir, @type, "**")
			filenames = Dir.glob(glob)
			filenames.map { |file| file.split(".")[0] }.uniq.map { |file| Source.new(file, type: @type) }
		end
	end
end
