require 'ltx'

module Ltx
	class Source
		def initialize(base, options={})
			options = {type: "other"}.merge(options)
			@base = base
			@type = options.fetch :type
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
			selected.source= self if selected.respond_to? :source=
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
			files.map { |sec| 
				SourceFile.for(sec).tap do |s|
					s.source= self if s.respond_to? :source=
				end
			}
		end
	end
end
