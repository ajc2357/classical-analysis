# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'classical_analysis/version'

Gem::Specification.new do |gem|
  gem.name          = "classical_analysis"
  gem.version       = ClassicalAnalysis::VERSION
  gem.authors       = ["Carl Hall"]
  gem.email         = ["carl@hallwaytech.com"]
  gem.description   = %q{Analyze categories of music played on allclassical.org.}
  gem.summary       = %q{Analyze categories of music played on allclassical.org.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('nokogiri')
  gem.add_dependency('mysql')
end
