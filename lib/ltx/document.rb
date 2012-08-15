require 'ltx'

module Ltx
	#TODO move to seperate file
	module GlossaryDocumentExtension
		def glossary?
			@glossary || false
		end

		def glossary
			@glossary = true
		end
	end

	#TODO move to seperate file
	module BibliographyDocumentExtension
		def bibliography?
			@bibtex || false
		end

		def bibliography(file=nil)
			@bibtex_files ||= [] unless file.nil?
			@bibtex_files << file unless file.nil?
			@bibtex = true
		end

		def bibliographies
			@bibtex_files || [primary.file("bib",true)]
		end
	end

	class Document
		include GlossaryDocumentExtension
		include BibliographyDocumentExtension
		
		# Public: Create a new document.
		#
		# primary - The basename for the document.
		# options - A hash of options (:directories to override default directories)
		#
		# Returns Document you created.
		def initialize(primary, options={})
			raise "primary can't be nil" if primary.nil?
			@primary = Source.new(primary, type: "primary")
			options = {directories: default_dirs}.merge(options)
			@directories = options.fetch :directories
		end

		def rescan
			@primary.rescan	
			@directories.each &:rescan
		end

		def chain
			[
			Generators::PdflatexGenerator.maybe?(self)
			].compact
		end

		def compile
			chain.each &:generate
		rescue
			#an error has occured during compile
		end
		
		def clean(full=false)
			chain.each do |gen|
				gen.clean(full)
			end
		end

		def primary
			@primary
		end

		def base
			primary.base
		end

		def basedir
			File.dirname primary.to_s
		end

		def find_by_type(type)
			([primary.file(type, false)] + directories.map { |dir| dir.find_by_type(type) }.flatten).compact
		end

		def directories
			@directories
		end

		def directory(type)
			directories.select { |dir| dir.type == type }
		end

		def to_s
			primary.to_s
		end

		def inspect
			"<@primary => #{primary.inspect}, @directories => #{directories.inspect}>"
		end

		private

		def default_dirs
			[
				SourceDirectory.new(self, "chapters"),
				SourceDirectory.new(self, "appendices"),
				SourceDirectory.new(self, "frontmatter"),
				SourceDirectory.new(self, "primary", manual: true) do |p|
					p.include("chapters", basedir) #chapters.tex
					p.include("appendices", basedir) #appendices.tex
				end

			]
		end
	end
end
