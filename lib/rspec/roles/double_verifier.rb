require_relative 'errors'

module RSpec
  module Roles
    class DoubleVerifier
      class << self
        def verify(double)
          meeting_expectations?(double) &&
            calling_existing_methods?(double) &&
            matching_arity?(double) &&
            providing_expected_arguments?(double)
        end

        private

        def calling_existing_methods?(double)
          not_existent = double.called_methods - double.existing_methods
          not_existent.empty? || raise(NotImplemented.new(double.name, not_existent))
        end

        def meeting_expectations?(double)
          not_called = double.expected_methods - double.called_methods
          not_called.empty? || raise(ExpectationNotMet.new(double.name, not_called))
        end

        def providing_expected_arguments?(double)
          double.calls.all? do |method_name, args|
            expected = double.expected_args(method_name)
            args == expected || raise(WrongArguments.new(double.name, method_name, args, expected))
          end
        end

        def matching_arity?(double)
          double.calls.all? do |method_name, args|
            actual = double.existing_arity(method_name)
            called = args.size
            called == actual || raise(WrongArity.new(double.name, method_name, called, actual))
          end
        end
      end
    end
  end
end
