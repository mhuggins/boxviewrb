# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'boxview/version'

Gem::Specification.new do |spec|
  spec.name          = "boxview.rb"
  spec.version       = BoxView::VERSION
  spec.authors       = ["Vincent Taverna"]
  spec.email         = ["vinnymac@gmail.com"]
  spec.summary       = "Wrapper for the BoxView API"
  spec.description   = "Box View converts PDF and Office documents to HTML thus enabling these files to be easily embedded into web and mobile applications."
  spec.homepage      = "http://developers.box.com/view/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency 'httmultiparty', '~> 0.3.14'
end