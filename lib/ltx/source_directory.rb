require 'ltx'

module Ltx
	class SourceDirectory
		def initialize(document, dir, options={})
			options = {manual: false, type: dir}.merge(options)
			@document = document
			@dir = dir
			@type = options.fetch :type
			@manual = options.fetch :manual

			@sources = if @manual
					  []
				  else
					  find_sources
				  end
			yield self if block_given?
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
		
		def find_by_base(base,force=false)
			output = sources.find do |source|
				source.base == base
			end
			if output.nil? && force
				Source.new(base)
			end
		end

		# Public: manually include a directory.
		#
		# basedir - By default it is nil, however if you specify it, it will base source on it.
		#
		# Returns nothing.
		def include(source, base=nil)
			source = File.join(base, source.to_s) unless base.nil?
			@sources << Source.new(source.to_s, type: @type)
		end
		
		def type
			@type
		end

		def to_s
			type
		end

		def inspect
			"<@type => #{type.inspect}, @glob = #{File.join(@document.basedir, @dir, "**")}, @dir => #{@dir.inspect}, @sources => #{sources.inspect} >"
		end

		private

		def find_sources
			glob = File.join(@document.basedir, @dir, "**").sub /^.\//, ""
			filenames = Dir.glob(glob)
			filenames.map { |file| file.split(".")[0] }.uniq.map { |file| Source.new(file, type: @type) }
		end
	end
end
