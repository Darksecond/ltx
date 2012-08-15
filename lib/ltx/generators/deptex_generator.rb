require 'ltx'

module Ltx::Generators
	class DeptexGenerator
		include Ltx::Log

		def self.maybe?(document, options={})
			new document, options
		end

		def initialize(document, options={})
			@document = document
		end

		def generate
			types.each do |k, v|
				output = []
				dirs = @document.directory(k)
				dirs.each do |d|
					output += d.find_by_type("tex").map { |s| "\\#{v.to_s}{#{s.base}}" }
				end
				File.open @document.directory("primary").first.find_by_base(k,true).file("tex", true), "w" do |f|
					output.each { |o| f.puts o }
				end
			end
		end

		def clean(full)
		end

		private

		def types
			{
				"frontmatter" => :input,
				"chapters" => :include,
				"appendices" => :include
			}
		end
	end
end
