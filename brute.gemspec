# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'brute/version'

Gem::Specification.new do |spec|
  spec.name          = "brute"
  spec.version       = Brute::VERSION
  spec.authors       = ['Anthony Bargnesi']
  spec.email         = ['abargnesi@gmail.com']

  spec.summary       = 'Experiment with a command until it fails.'
  spec.description   = 'A light framework for testing a command for the failure scenario. Similar to git-bisect, but more generic.'

  spec.homepage      = 'https://github.com/abargnesi/brute'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(features|spec|test|tools)/}) }
  spec.executables   = Dir.glob('bin/*').map(&File.method(:basename))
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
