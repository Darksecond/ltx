
module Ltx
	class ExtensionTracker
		def self.create_from_tracker(original)
			ExtensionTracker.new(original.extension, original.document,
					     previous: original
					    )
		end

		def initialize(ext, document, options={})
			@extension = ext.to_s
			@document = document
			options = {previous: nil}.merge(options)
			@previous = options.fetch :previous
			@checksums = []
			update!
		end

		def extension
			@extension
		end

		def document
			@document
		end

		def update
			ExtensionTracker.create_from_tracker(self)
		end

		def update!
			files = document.find_by_type(extension)
			files.each do |file|
				@checksums << file.checksum
			end
		end

		def changed?
			prev = @previous.checksums if @previous
			if prev.count != @checksums.count
				return true
			end

			if prev != @checksums
				return true
			end
		end

		def checksums
			@checksums
		end

	end
end
