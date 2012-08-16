require 'ltx'

module Ltx
	class MltxSourceFile < SourceFile
		def source=(source)
			@source = source
		end

		def manifest
			#parse and return
			@manifest ||= MltxSourceFile::Mltx.new.parse(file)
		end

		class Mltx
			def parse(file)
				instance_eval(File.read(file))
				@manifest
			end

			def manifest(&block)
				#manifest = Manifest.new(@source)
				MltxSourceFile::Manifest.new(manifest).instance_exec &block
				#@manifest = manifest
			end
		end

		class Manifest
			def initialize(manifest)
				@manifest = manifest
			end

			#def ...
		end
	end
end
