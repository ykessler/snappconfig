# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "snappconfig"
  spec.version       = "0.0.5"
  spec.authors       = ["Yarin Kessler"]
  spec.email         = ["ykessler@gmail.com"]
  spec.description   = %q{Easy Heroku-friendly Rails configuration with a single YAML file}
  spec.summary       = %q{Easy Heroku-friendly Rails configuration with a single YAML file}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
