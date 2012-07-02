require 'ltx'

module Ltx
	class AuxSourceFile < SourceFile
		def used_citations
			parse[0]
		end

		def databases
			parse[1]
		end

		private

		def parse
			return [[],[]] unless exists?
			citations = []
			dbs = []
			File.open(file) do |aux|
				until aux.eof?
					line = aux.readline.strip!
					match = /\\citation{(?<cite>.*)}/.match(line)
					if match
						citations << match[:cite]
					end
					match = /\\bibdata{(?<data>.*)}/.match(line)
					if match
						dbs += match[:data].split(",")
					end
				end
			end
			[citations, dbs]
		end
	end
end
