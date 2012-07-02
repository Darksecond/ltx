require 'ltx'

module Ltx
	class Source
		def initialize(base)
			@base = base
			@type = find_type
			rescan
		end

		def rescan
			@files = find_files
		end

		def base
			@base
		end

		def file(type, force=false)
			selected = @files.select { |sec| sec.type == type }.first
			if force && selected == nil
				selected = SourceFile.for "#{base}.#{type}"
			end
			selected
		end

		def files
			@files
		end

		def type
			@type
		end

		def to_s
			base
		end

		def inspect
			"<@base => #{base.inspect}, @type => #{type.inspect}, @secondaries => #{files.inspect}>"
		end

		def ==(other)
			return false if other.nil?
			self.base == other.base
		end

		def eql?(other)
			self.==(other)
		end

		def hash
			base.hash
		end

		private

		def find_files
			files = Dir.glob("#{base}.*")
			files.map { |sec| SourceFile.for sec }
		end

		def find_type
			type = base.to_s.split("/")[0]
			unless types.include? type
				"primary"
			end
		end

		def types
			["chapters", "appendices", "frontmatter"]
		end
	end
end
