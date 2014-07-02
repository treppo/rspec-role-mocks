module RSpec
  module Roles
    class Double
      def initialize(name, role)
        @called_methods = []
        @expectations = []
        @name = name
        @role = role
      end

      def verify
        called_expected_methods? && only_called_existing_methods?
      end


      def add_expectation(method_name)
        @expectations << method_name
      end

      def method_missing(method, *args)
        @called_methods << method
      end

      private

      def only_called_existing_methods?
        not_existent = @called_methods - @role.instance_methods(false)
        not_existent.empty? ||
          fail("role #{@name} does not implement: ##{not_existent.first}")
      end

      def called_expected_methods?
        not_called = @expectations - @called_methods
        not_called.empty? ||
          fail("expected method call to ##{not_called.first} was never made")
      end
    end
  end
end
