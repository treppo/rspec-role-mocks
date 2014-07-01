require 'rspec/roles/double'
require 'rspec/roles/matchers/receive'

module RSpec
  module Roles
    module ExampleMethods
      def role_double(name)
        RSpec::Roles::Doubles.register(
          RSpec::Roles::Double.new(
            RSpec::Roles.loaded_roles.fetch(name)))
      end

      def receive(method_name, &block)
        RSpec::Roles::Matchers::Receive.new(method_name)
      end
    end
  end
end
