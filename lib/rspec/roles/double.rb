require_relative 'errors'

module RSpec
  module Roles
    class Double
      def initialize(name, role)
        @called_methods = {}
        @expectations = {}
        @return_values = {}
        @name = name
        @role = role
      end

      def verify
        meeting_expectations? &&
          calling_existing_methods? &&
          matching_arity? &&
          providing_expected_arguments?
      end

      def add_expectation(method_name, args)
        @expectations[method_name] = args
      end

      def add_return_value(method_name, return_value)
        @return_values[method_name] = return_value
      end

      private

      def method_missing(method, *args)
        @called_methods[method] = args || []
        @return_values[method] if @return_values[method]
      end

      def calling_existing_methods?
        not_existent = @called_methods.keys - @role.instance_methods(false)
        not_existent.empty? || raise(NotImplemented.new(@name, not_existent))
      end

      def meeting_expectations?
        not_called = @expectations.keys - @called_methods.keys
        not_called.empty? || raise(ExpectationNotMet.new(@name, not_called))
      end

      def providing_expected_arguments?
        @called_methods.all? do |method_name, args|
          args == @expectations[method_name] || raise(WrongArguments.new(@name, method_name, args, @expectations[method_name]))
        end
      end

      def matching_arity?
        @called_methods.all? do |method_name, args|
          expected = @role.instance_method(method_name).arity
          actual = args.size
          actual == expected || raise(WrongArity.new(@name, method_name, actual, expected))
        end
      end
    end
  end
end
