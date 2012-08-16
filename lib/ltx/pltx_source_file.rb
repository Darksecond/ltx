require 'ltx'

module Ltx
	class PltxSourceFile < SourceFile

		# Public: Holds the generated documents.
		#
		# Returns the generated documents.
		def documents
			@documents ||= PltxSourceFile::Pltx.new.parse(file)
		end

		private
		
		#TODO refactor!
		class Pltx
			def parse(file)
				@documents = []
				instance_eval(File.read(file))
				@documents
			end

			def document(filename, &block)
				document = Ltx::Document.new filename
				PltxSourceFile::Document.new(document).instance_exec &block
				@documents << document #if document.valid? #TODO
			end
		end

		class Document
			def initialize(document)
				@document = document
			end

			def glossary
				@document.glossary
			end

			def bibliography(file=nil)
				if file.nil?
					default = [@document.primary.file("bib",true)]
					@document.set_option(:bibliographies, default)
				else
					bibs = @document.option(:bibliographies, [])
					bibs << SourceFile.for(file, "bib")
				end
			end
		end
	end
end
