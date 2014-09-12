require 'rspec/role-mocks/version'
require 'rspec/role-mocks/repository'
require 'rspec/role-mocks/definition'
require 'rspec/role-mocks/conformance'
require 'rspec/role-mocks/example_methods'
require 'rspec/role-mocks/doubles'
require 'rspec/role-mocks/adapter'
require 'rspec/core'

module RSpec
  module RoleMocks
    @@loaded_roles = Repository.new

    def self.loaded_roles
      @@loaded_roles
    end
  end
end

RSpec.configure do |rspec|
  rspec.extend RSpec::RoleMocks::Conformance
  rspec.include RSpec::RoleMocks::ExampleMethods
  rspec.mock_framework = RSpec::RoleMocks::Adapter
end
