module Ltx
	class SourceFile
		def initialize(file, ext=nil)
			@file = file
			if extension == "" && ext
				@file += ".#{ext}"
			end
		end

		def file
			@file
		end

		def type
			filename.partition(".").last
		end

		def extension
			#File.extname(filename)[1..-1]
			type
		end

		def base
			file.chomp ".#{extension}"
		end

		def basedir
			File.dirname file
		end

		def filename
			File.split(file)[1]
		end

		def to_s
			file
		end

		def inspect
			"[@file => #{file.inspect}, @type => #{type.inspect}]"
		end
	end
end
