require 'rspec/roles/double'
require 'rspec/roles/matchers/receive'

module RSpec
  module Roles
    module ExampleMethods
      def role_double(name, allowed = {})
        RSpec::Roles::Doubles.register(
          RSpec::Roles::Double.new(name,
            RSpec::Roles.loaded_roles.fetch(name), allowed: allowed))
      end

      def receive(method_name)
        RSpec::Roles::Matchers::Receive.new(method_name)
      end
    end
  end
end
