# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gdexpress/version'

Gem::Specification.new do |spec|
  spec.name          = "gdexpress"
  spec.version       = Gdexpress::VERSION
  spec.authors       = ["Patricio Bruna"]
  spec.email         = ["pbruna@gmail.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = "https://github.com/pbruna/gdexpress"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_runtime_dependency 'nokogiri'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "turn"
  spec.add_development_dependency "sinatra"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency 'minitest-reporters', '~> 1.0.0.beta3'
  
end
