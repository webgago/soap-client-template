# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "soap-client-template/version"

Gem::Specification.new do |s|
  s.name        = "soap-client-template"
  s.version     = Soap::Client::Template::VERSION
  s.authors     = ["Anton Sozontov"]
  s.email       = ["asozontov@at-consulting.ru"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "soap-client-template"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"

  s.add_runtime_dependency "libxml-ruby"
  s.add_runtime_dependency "railties"
  s.add_runtime_dependency "activesupport"
end
