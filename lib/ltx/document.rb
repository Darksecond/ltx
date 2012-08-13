require 'ltx'

module Ltx
	class Document
		#options
		##generators
		##modules
		#make directories a little more user friendly to specify
		
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

		def compile
			[
			Generators::PdflatexGenerator.maybe?(self)
			].compact.each &:generate
		end
		
		def clean
			raise "not yet implemented"
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
			directories.select { |dir| dir.type == type }.first
		end

		def to_s
			primary.to_s
		end

		def inspect
			"<@primary => #{primary.inspect}, @directories => #{directories.inspect}>"
		end

		#--- PDFLATEX ---#
		#---   BIBER  ---#
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

		#--- GLOSSARIES ---#
		def glossary?
			@glossary || false
		end

		def glossary
			@glossary = true
		end

		private

		def default_dirs
			pdir = SourceDirectory.new(self, "primary", manual: true)
			pdir.include(File.join(basedir, "chapters"))
			pdir.include(File.join(basedir, "appendices"))

			[
				SourceDirectory.new(self, "chapters"),
				SourceDirectory.new(self, "appendices"),
				SourceDirectory.new(self, "frontmatter"),
				pdir
			]
		end
	end
end
