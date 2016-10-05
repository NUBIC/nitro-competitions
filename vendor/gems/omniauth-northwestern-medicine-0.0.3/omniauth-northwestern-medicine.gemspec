# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-northwestern-medicine/version'

Gem::Specification.new do |spec|
  spec.name          = 'omniauth-northwestern-medicine'
  spec.version       = OmniAuth::NorthwesternMedicine::VERSION
  spec.authors       = ['Luke Rasmussen', 'Matthew Baumann']
  spec.email         = ['luke.rasmussen@northwestern.edu', 'matthew.baumann@northwestern.edu']
  spec.description   = %q{OmniAuth strategy for Northwestern Medicine}
  spec.summary       = %q{OmniAuth strategy for Northwestern Medicine}
  spec.homepage      = ''

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'omniauth', '~> 1.0'
  spec.add_runtime_dependency 'multi_xml'

  spec.add_development_dependency 'rspec', '~> 2.7'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'simplecov'
end
