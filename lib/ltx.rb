module Ltx
	require 'pry'

	autoload :VERSION, 'ltx/version'
	autoload :Document, 'ltx/document'
	autoload :ExtensionTracker, 'ltx/extension_tracker'
	autoload :FileTracker, 'ltx/file_tracker'
	autoload :LogSourceFile, 'ltx/log_source_file'
	autoload :AuxSourceFile, 'ltx/aux_source_file'
	autoload :Source, 'ltx/source'
	autoload :SourceFile, 'ltx/source_file'
	autoload :SourceDirectory, 'ltx/source_directory'

	module Commands
		autoload :BiberCommand, 'ltx/commands/biber_command'
		autoload :MakeglossariesCommand, 'ltx/commands/makeglossaries_command'
		autoload :PdflatexCommand, 'ltx/commands/pdflatex_command'
	end

	module Generators
		autoload :PdflatexGenerator, 'ltx/generators/pdflatex_generator'
		autoload :Step, 'ltx/generators/step'
	end

	module Modules
		autoload :BiberModule, 'ltx/modules/biber_module'
		autoload :MakeglossariesModule, 'ltx/modules/makeglossaries_module'
	end
	
	module Log

		def log!(who, what)
			@log ||= []
			Array(what).each do |line|
				#who.class.to_s.split("::").last -> only the class name, not the namespacing
				@log << who.class.to_s.split("::").last + ": " + line.to_s
			end
		end

		def log
			@log
		end
	end
end
