# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'microbilt/version'

Gem::Specification.new do |spec|
  spec.name          = "microbilt"
  spec.version       = Microbilt::VERSION
  spec.authors       = ["nick.hanley"]
  spec.email         = ["nickh@mogo.com"]
  spec.summary       = %q{Provides interface for MicroBilt IBV}
  spec.description   = %q{Provides capability to verify banking information}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  # spec.executables   = ["test"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency 'rake', '~> 10.3', '>= 10.3.2'

  spec.add_runtime_dependency 'typhoeus', '~> 0.6', '>= 0.6.3'
end
