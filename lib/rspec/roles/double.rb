module RSpec
  module Roles
    class Double
      attr_reader :name, :role

      def initialize(name, role)
        @calls = {}
        @expectations = {}
        @return_values = {}
        @name = name
        @role = role
      end

      def add_expectation(method_name, args)
        @expectations[method_name] = args
      end

      def add_return_value(method_name, return_value)
        @return_values[method_name] = return_value
      end

      def calls
        @calls
      end

      def called_methods
        @calls.keys
      end

      def existing_methods
        @role.instance_methods(false)
      end

      def expected_methods
        @expectations.keys
      end

      def expected_args(method)
        @expectations[method]
      end

      def existing_arity(method)
        @role.instance_method(method).arity
      end

      private

      def method_missing(method, *args)
        @calls[method] = args || []
        @return_values[method] if @return_values[method]
      end
    end
  end
end
