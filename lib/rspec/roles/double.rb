module RSpec
  module Roles
    class Double
      def initialize(name, role)
        @called_methods = {}
        @expectations = []
        @name = name
        @role = role
      end

      def verify
        called_expected_methods? &&
          only_called_existing_methods? &&
          equal_called_and_existing_arity?
      end


      def add_expectation(method_name)
        @expectations << method_name
      end

      private

      def method_missing(method, *args)
        @called_methods[method] = (args || []).size
      end

      def only_called_existing_methods?
        not_existent = @called_methods.keys - @role.instance_methods(false)
        not_existent.empty? ||
          fail("role #{@name} does not implement: ##{not_existent.first}")
      end

      def called_expected_methods?
        not_called = @expectations - @called_methods.keys
        not_called.empty? ||
          fail("expected method call to ##{not_called.first} was never made")
      end

      def equal_called_and_existing_arity?
        @called_methods.keys.all? do |method_name|
          @called_methods[method_name] == @role.instance_method(method_name).arity ||
            fail("Wrong number of arguments for ##{method_name}")
        end
      end
    end
  end
end
