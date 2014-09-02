require_relative 'errors'

module RSpec
  module Roles
    class Verifier
      def initialize(name, calls, role, expectations)
        @name = name
        @calls = calls
        @role = role
        @expectations = expectations
      end

      def methods_defined
        not_existent = @calls.methods - @role.instance_methods
        not_existent.empty? || raise(NotImplemented.new(@name, not_existent))
      end

      def matching_arity
        @calls.all? do |method_name, args|
          actual = @role.instance_method_arity(method_name)
          called = args.size
          called == actual || raise(WrongArity.new(@name, method_name, called, actual))
        end
      end

      def providing_expected_arguments
        @calls.all? do |method_name, args|
          expected = @expectations.args(method_name)
          args == expected || raise(WrongArguments.new(@name, method_name, args, expected))
        end
      end

      def made_expected_calls
        not_called = @expectations.methods - @calls.methods
        not_called.empty? || raise(ExpectationNotMet.new(@name, not_called))
      end
    end
  end
end
