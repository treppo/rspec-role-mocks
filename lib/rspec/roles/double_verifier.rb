require_relative 'errors'

module RSpec
  module Roles
    class DoubleVerifier
      def self.verify(double)
        new(double).verify
      end

      def initialize(double)
        @double = double
      end

      def verify
        made_expected_calls &&
          methods_defined &&
          matching_arity &&
          providing_expected_arguments
      end

      def methods_defined
        not_existent = @double.called_methods - @double.existing_methods
        not_existent.empty? || raise(NotImplemented.new(@double.name, not_existent))
      end

      def matching_arity
        @double.calls.all? do |method_name, args|
          actual = @double.existing_arity(method_name)
          called = args.size
          called == actual || raise(WrongArity.new(@double.name, method_name, called, actual))
        end
      end

      def providing_expected_arguments
        @double.calls.all? do |method_name, args|
          expected = @double.expected_args(method_name)
          args == expected || raise(WrongArguments.new(@double.name, method_name, args, expected))
        end
      end

      def made_expected_calls
        not_called = @double.expected_methods - @double.called_methods
        not_called.empty? || raise(ExpectationNotMet.new(@double.name, not_called))
      end
    end
  end
end
