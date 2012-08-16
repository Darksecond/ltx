module Ltx
	require 'pry'
	require 'logger'

	autoload :VERSION, 'ltx/version'
	autoload :CLI, 'ltx/cli'
	autoload :Document, 'ltx/document'
	autoload :ExtensionTracker, 'ltx/extension_tracker'
	autoload :FileTracker, 'ltx/file_tracker'
	autoload :LogSourceFile, 'ltx/log_source_file'
	autoload :AuxSourceFile, 'ltx/aux_source_file'
	autoload :PltxSourceFile, 'ltx/pltx_source_file'
	autoload :MltxSourceFile, 'ltx/mltx_source_file'
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
		autoload :DeptexGenerator, 'ltx/generators/deptex_generator'
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

		def debug(what)
			logger.debug pretty_class + " - " + what
		end

		def info(what)
			logger.info pretty_class + " - " + what
		end

		def warn(what)
			logger.warn pretty_class + " - " + what
		end

		def error(what)
			logger.error pretty_class + " - " + what
		end

		private

		def pretty_class
			pretty = self.class.to_s
			pretty.sub! "Ltx::", ""
			pretty
		end
	end
end
