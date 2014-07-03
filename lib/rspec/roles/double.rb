module RSpec
  module Roles
    class Double
      def initialize(name, role)
        @called_methods = {}
        @expectations = {}
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

      private

      def method_missing(method, *args)
        @called_methods[method] = args || []
      end

      def calling_existing_methods?
        not_existent = @called_methods.keys - @role.instance_methods(false)
        not_existent.empty? ||
          fail("role #{@name} does not implement: ##{not_existent.first}")
      end

      def meeting_expectations?
        not_called = @expectations.keys - @called_methods.keys
        not_called.empty? ||
          fail("expected method call to ##{not_called.first} was never made")
      end

      def providing_expected_arguments?
        @called_methods.all? do |method_name, args|
          args == @expectations[method_name] ||
            fail("""
                 Method ##{method_name} received wrong arguments: #{args.to_s[1..-2]}
                 expected arguments: #{@expectations[method_name].to_s[1..-2]}
                 """)
        end
      end

      def matching_arity?
        @called_methods.all? do |method_name, args|
          args.size == @role.instance_method(method_name).arity ||
            fail("Wrong number of arguments for ##{method_name}")
        end
      end
    end
  end
end
