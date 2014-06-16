# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/roles/version'

Gem::Specification.new do |spec|
  spec.name = "rspec-roles"
  spec.version = Rspec::Roles::VERSION
  spec.authors = ["Christian Treppo"]
  spec.email = ["christian@treppo.org"]
  spec.summary = %q{Test if objects fulfill a certain role}
  spec.description = %q{TODO}
  spec.license = "GPLv3"
  spec.homepage = "https://github.com/treppo/rspec-roles"

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rb-readline"
  spec.add_runtime_dependency "rspec", "~> 3.0"
end
