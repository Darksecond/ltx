
module Ltx
	class FileTracker
		def self.create_from_tracker(original)
			FileTracker.new(original.source, 
					previous: original
				       )
		end

		def initialize(sourcefile, options={})
			@source = sourcefile
			options = {previous: nil}.merge(options)
			@previous = options.fetch :previous
			update!
		end

		def source
			@source
		end

		def update
			FileTracker.create_from_tracker(self)
		end

		def update!
			@checksum = source.checksum
		end

		def changed?
			prev = @previous.checksum if @previous
			prev != checksum
		end

		def checksum
			@checksum
		end
	end
end
