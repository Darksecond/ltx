require 'ltx'

module Ltx
	class DSL
		def self.exec(&block)
			dsl = new
			dsl.instance_exec &block
			dsl.documents
		end

		def self.eval(filename)
			dsl = new
			dsl.instance_eval(File.read(filename))
			dsl.documents
		end

		def initialize
			@documents = []
		end

		def document(filename, &block)
			document = Ltx::Document.new filename
			document.instance_exec &block
			@documents << document #if document.valid? #TODO
		end

		def documents
			@documents
		end
	end
end
