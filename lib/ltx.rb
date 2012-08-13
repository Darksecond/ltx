module Ltx
	require 'pry'
	require 'logger'

	autoload :VERSION, 'ltx/version'
	autoload :DSL, 'ltx/dsl'
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

		def logger
			@@logger ||= Logger.new STDOUT #replace with variable to stdout or file?
		end

		def debug(who, what)
			logger.debug who.class.to_s + " - " + what
		end

		def info(who, what)
			logger.info who.class.to_s + " - " + what
		end

		def warn(who, what)
			logger.warn who.class.to_s + " - " + what
		end

		def error(who, what)
			logger.error who.class.to_s + " - " + what
		end
	end
end
