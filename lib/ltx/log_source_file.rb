require 'ltx'

module Ltx
	class LogSourceFile < SourceFile
		def lines
			lines = []
			prev = ""
			File.open(file) do |file|
				until file.eof?
					line = file.readline.strip!
					if line.length == 79
						prev += line
					elsif line.length == 0
						lines << prev if prev != ""
						prev = ""
					else
						prev += line
						lines << prev
						prev = ""
					end
				end
			end
			lines
		end

		def rerun_needed?
			return true unless exists?
			lines.each do |line|
				if (line =~ /LaTeX Warning:.*Rerun/) != nil
					return true
					#elsif
				end
			end
			return false
		end

		def undefined_citations
			return [] unless exists?
			undefs = []
			lines.each do |line|
				match = /LaTeX Warning: Citation `(?<cite>.*)' .*undefined.*/.match(line)
				if match
					undefs << match[:cite]
				end
			end
			undefs
		end
	end
end
