# -*- encoding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/lib/webmock_method/version')

Gem::Specification.new do |spec|
  spec.name          = "webmock_method"
  spec.summary       = %q{Extension for webmock to make stubbed methods.}
  spec.description   = %q{Extension for webmock to make stubbed methods.}
  spec.email         = "alexander.shvets@gmail.com"
  spec.authors       = ["Alexander Shvets"]
  spec.homepage      = "http://github.com/shvets/webmock_method"

  spec.files         = `git ls-files`.split($\)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.version       = WebmockMethod::VERSION
  spec.license       = "MIT"

  
  spec.add_runtime_dependency "webmock", [">= 0"]
  spec.add_runtime_dependency "haml", [">= 0"]
  spec.add_runtime_dependency "meta_methods", [">= 0"]
  spec.add_development_dependency "gemspec_deps_gen", [">= 0"]
  spec.add_development_dependency "gemcutter", [">= 0"]

end




