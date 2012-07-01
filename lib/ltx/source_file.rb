require 'digest/md5'

module Ltx
	class SourceFile
		def initialize(file, ext=nil)
			@file = file.to_s
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

		def ==(other)
			return false if other.nil?
			self.file == other.file
		end

		def eql?(other)
			self.==(other)
		end

		def hash
			file.hash
		end

		def checksum
			return nil unless exists?
			Digest::MD5.file(file).to_s
		end

		def exists?
			File.exists? file
		end
	end
end
