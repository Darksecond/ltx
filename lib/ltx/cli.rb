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
		def clean(project=DEFAULT)
			docs(project).each &:clean
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
			Ltx::DSL.eval project
		end
	end
end
