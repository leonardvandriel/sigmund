# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sigmund/version'

Gem::Specification.new do |spec|
  spec.name          = "sigmund"
  spec.version       = Sigmund::VERSION
  spec.authors       = ["Leo Vandriel"]
  spec.email         = ["mail@leovandriel.com"]
  spec.description   = %q{Sign urls and verify signatures}
  spec.summary       = %q{Sign urls and verify signatures, easy!}
  spec.homepage      = "https://github.com/leovandriel/sigmund"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
