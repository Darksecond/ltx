require 'ltx/source'

module Ltx
	class Document
		#options
		##generators
		##modules
		
		def initialize(primary)
			raise "primary can't be nil" if primary.nil?
			rescan primary
		end

		def rescan(primary)
			@primary = Source.new primary
			@secondaries = find_secondaries
		end

		def compile
			#TODO...
		end

		def primary
			@primary
		end

		def base
			primary.chomp ".tex"
		end

		def basedir
			File.dirname primary
		end

		def find_by_type(type)
			([primary.secondary(type)] + secondaries.map { |sec| sec.secondary(type) }).compact
		end

		def secondaries
			@secondaries
		end

		def to_s
			primary.to_s
		end

		def inspect
			"[@primary => #{primary.inspect}, @secondaries => #{secondaries.inspect}]"
		end

		private

		def find_secondaries
			#going to assume that the base directory is the same the primary is in
			sec_dirs_regexp = "{#{secondary_dirs.join(",")}}"
			types_regexp = "{#{secondary_types.join(",")}}"

			secondaries = Dir.glob("#{sec_dirs_regexp}/**/*.{#{types_regexp}}")
			secondaries.map { |sec| Source.new sec }
		end

		def secondary_dirs
			["chapters", "appendices", "frontmatter"]
		end

		def secondary_types
			["tex"]
		end
	end
end
