require 'rspec/roles/version'
require 'rspec/roles/repository'
require 'rspec/roles/definition'
require 'rspec/roles/conformance'
require 'rspec/roles/example_methods'
require 'rspec/roles/doubles'
require 'rspec/roles/adapter'
require 'rspec/core'

module RSpec
  module Roles
    @@loaded_roles = Repository.new

    def self.loaded_roles
      @@loaded_roles
    end
  end
end

RSpec.configure do |rspec|
  rspec.extend RSpec::Roles::Conformance
  rspec.include RSpec::Roles::ExampleMethods
  rspec.mock_framework = RSpec::Roles::Adapter
end
