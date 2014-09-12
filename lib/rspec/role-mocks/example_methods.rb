require 'rspec/role-mocks/double'
require 'rspec/role-mocks/matchers/receive'

module RSpec
  module RoleMocks
    module ExampleMethods
      def role_double(name, allowed = {})
        RSpec::RoleMocks::Doubles.register(
          RSpec::RoleMocks::Double.new(name,
            RSpec::RoleMocks.loaded_roles.fetch(name), allowed: allowed))
      end

      def receive(method_name)
        RSpec::RoleMocks::Matchers::Receive.new(method_name)
      end
    end
  end
end
