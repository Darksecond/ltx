# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ltx/version"

Gem::Specification.new do |s|
  s.name        = "ltx"
  s.version     = Ltx::VERSION
  s.authors     = ["Tim Peters"]
  s.email       = ["mail@darksecond.nl"]
  s.homepage    = ""
  s.summary     = %q{LaTeX dependency resolver and compiler} #a few words
  s.description = %q{a LaTeX dependency resolver and compiler, it will compile makeglossaries and biber as well} #longer description

  s.rubyforge_project = "ltx"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
