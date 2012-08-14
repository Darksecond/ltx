require 'ltx'

module Ltx
	class DSL
		# Public: exec a block of DSL code
		def self.exec(&block)
			dsl = new
			dsl.instance_exec &block
			dsl.documents
		end

		# Public: eval a file for DSL code
		def self.eval(filename)
			dsl = new
			dsl.instance_eval(File.read(filename))
			dsl.documents
		end

		# Internal: initialize new DSL object
		def initialize
			@documents = []
		end

		# Public: Part of the top-level DSL.
		def document(filename, &block)
			document = Ltx::Document.new filename
			document.instance_exec &block
			@documents << document #if document.valid? #TODO
		end

		# Public: Holds the generated documents.
		#
		# Returns the generated documents.
		def documents
			@documents
		end
	end
end
