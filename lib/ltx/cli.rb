require 'ltx'
require 'thor'

module Ltx
	class CLI < Thor
		EXTENSION = ".pltx"
		DEFAULT = "project"
		default_task "compile"

		desc "compile [project]", "compile a project"
		def compile(project=DEFAULT)
			#compile each document
			docs(project).each &:compile
		end

		desc "clean [project]", "remove all temporary files for a project"
		method_option :full, :type => :boolean, :desc => "do a full clean (also remove output pdf)", :aliases => "-f"
		def clean(project=DEFAULT)
			docs(project).each do |doc|
				doc.clean options[:full]
			end
		end

		private

		def docs(project)
			if File.exists? project
				#do nothing
			elsif File.exists? project + EXTENSION
				project = project + EXTENSION
			else
				puts "The given project '#{project}' does not exist."
				exit 1
			end
			#parse project
			PltxSourceFile.new(project).documents
		end
	end
end
