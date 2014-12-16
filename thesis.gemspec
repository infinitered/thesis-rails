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

  gem.required_ruby_version     = '>= 2.0.0'

  gem.files         = Dir["{lib,app,config}/**/*"] + ["README.md", "LICENSE.txt"]
  gem.require_paths = ["lib", "app"]
  gem.test_files = Dir["spec/**/*"]

  gem.add_dependency "rails", "~> 4.0"
  gem.add_dependency "sass", ">= 3.3"
  gem.add_dependency "sass-rails", ">= 5.0"
end
