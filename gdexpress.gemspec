# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gdexpress/version'

Gem::Specification.new do |spec|
  spec.name          = "gdexpress"
  spec.version       = Gdexpress::VERSION
  spec.authors       = ["Patricio Bruna"]
  spec.email         = ["pbruna@gmail.com"]
  spec.description   = "GDexpress API Wrapper: www.gdexpress.cl"
  spec.summary       = ["Permite comunicarse con la API WS de GDexpress para emitir DTEs en Chile"]
  spec.homepage      = "https://github.com/pbruna/gdexpress"
  spec.license       = "MIT"
  spec.required_ruby_version = '~> 2.0'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_runtime_dependency 'nokogiri', "~> 1.6"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.4"
  spec.add_development_dependency "sinatra", "~> 1.4"
  spec.add_development_dependency "webmock", "~> 1.20"
  spec.add_development_dependency 'minitest-reporters', '~> 1.0.0.beta3'
  
end
