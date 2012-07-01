require 'ltx/source_file'

module Ltx
	class Source
		def initialize(primary)
			@primary = SourceFile.new primary.to_s, "tex"
			@type = find_type
			rescan
		end

		def rescan
			@secondaries = find_secondaries
		end

		def primary
			@primary
		end

		def base
			primary.base
		end

		def secondary(type)
			@secondaries.select { |sec| sec.type == type }.first
		end

		def secondaries
			@secondaries
		end

		def type
			@type
		end

		def to_s
			primary
		end

		def inspect
			"[@primary => #{primary.inspect}, @type => #{type.inspect}, @secondaries => #{secondaries.inspect}]"
		end

		private

		def find_secondaries
			secondaries = Dir.glob("#{base}.*")
			secondaries.delete "#{base}.#{primary.extension}"
			secondaries.map { |sec| SourceFile.new sec }
		end

		def find_type
			type = primary.to_s.split("/")[0]
			unless types.include? type
				"primary"
			end
		end

		def types
			["chapters", "appendices", "frontmatter"]
		end
	end
end
