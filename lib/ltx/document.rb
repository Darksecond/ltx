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

	class Document
		include GlossaryDocumentExtension
		
		# Public: Create a new document.
		#
		# primary - The basename for the document.
		# options - A hash of options (:directories to override default directories)
		#
		# Returns Document you created.
		def initialize(primary, options={})
			raise "primary can't be nil" if primary.nil?
			@primary = Source.new(primary, type: "primary")
			@options = {
				directories: default_dirs,
				bibliographies: [],
				glossary: false
			}.merge(options)
			@directories = option :directories
		end

		def rescan
			@primary.rescan	
			@directories.each &:rescan
		end

		def chain
			[
			Generators::DeptexGenerator.maybe?(self),
			Generators::PdflatexGenerator.maybe?(self)
			].compact
		end

		def compile
			chain.each &:generate
		#rescue
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

		def set_option(key, value)
			@options[key] = value
		end

		def option(key, default=nil)
			#TODO handle default better
			begin
				@options.fetch key
			rescue
				@options[key] = default
			end
		end

		def options
			@options
		end

		def option?(key)
			@options.has_key? key
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
