# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thesis/version'

Gem::Specification.new do |gem|
  gem.name          = "thesis"
  gem.version       = Thesis::VERSION
  gem.authors       = ["ClearSight Studio"]
  gem.email         = ["contact@clearsightstudio.com"]
  gem.description   = %q{Thesis: A Rails CMS that doesn't hijack your development workflow.}
  gem.summary       = %q{Thesis: A Rails CMS that doesn't hijack your development workflow.}
  gem.homepage      = "https://github.com/clearsightstudio/thesis"

  # gem.files         = `git ls-files`.split($/)
  gem.files         = Dir["{lib,vendor}/**/*"] + ["README.md"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency "railties", "~> 3.2"

  

end
