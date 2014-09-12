require_relative 'expectations'
require_relative 'verifier'
require_relative 'calls'

module RSpec
  module RoleMocks
    class Double
      def initialize(name, role, opts = {})
        @name = name
        @role = role
        @allowed_calls = opts[:allowed] || {}
        @calls = opts[:calls] || Calls.new
        @expectations = opts[:expectations] || Expectations.new
        @verifier = opts[:verifier] || Verifier.new(name, @calls, @role, @expectations)
      end

      def add_expectation(method_name, args, ret_val)
        @expectations.add(method_name, args, ret_val)
      end

      def verify
        @verifier.made_expected_calls &&
          @verifier.methods_defined &&
          @verifier.matching_arity &&
          @verifier.providing_expected_arguments
      end

      private

      def method_missing(method, *args)
        return @allowed_calls[method] if @allowed_calls[method]

        @calls.add(method, args)
        @expectations.ret_val(method) if @expectations.ret_val(method)
      end
    end
  end
end
