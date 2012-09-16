# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omeka-recipes/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Wayne Graham"]
  gem.email         = ["wayne.graham@virginia.edu"]
  gem.description   = %q{Capistrano recipes for Omeka}
  gem.summary       = %q{Capistrano recipes for deploying Omeka}
  gem.homepage      = "https://github.com/waynegraham/omeka-recipes"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "omeka-recipes"
  gem.require_paths = ["lib"]
  gem.version       = Omeka::Recipes::VERSION

  gem.extra_rdoc_files = %w(LICENSE README.md)

  gem.add_dependency "capistrano", ">= 2.5.9"
  gem.add_dependency "capistrano-ext", ">= 1.2.1"
  gem.add_dependency "capistrano-multistage", "~> 0.0.4"
  gem.add_dependency "capistrano-php", "~> 1.0.0"
end
