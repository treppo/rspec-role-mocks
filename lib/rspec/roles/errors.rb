module RSpec
  module Roles
    class Error < StandardError; end

    class NotImplemented < Error
      def initialize(role_name, method_names)
        @role_name = role_name
        @method_names = method_names
      end

      def to_s
        "role double #{@role_name} does not implement: #{@method_names.to_s[1..-2].gsub(/:/,'#')}"
      end
    end

    class ExpectationNotMet < Error
      def initialize(role_name, method_names)
        @role_name = role_name
        @method_names = method_names
      end

      def to_s
        "expected method call to #{@method_names.to_s[1..-2].gsub(/:/,'#')} on role double #{@role_name} was never made"
      end
    end

    class WrongArguments < Error
      def initialize(role_name, method_name, args, expected_args)
        @role_name = role_name
        @method_name = method_name
        @args = args
        @expected_args = expected_args
      end

      def to_s
        """
        Method ##{@method_name} on role double #{@role_name} received wrong arguments: #{@args.to_s[1..-2]}
        expected arguments: #{@expected_args.to_s[1..-2]}
        """
      end
    end

    class WrongArity < Error
      def initialize(role_name, method_name, actual, expected)
        @role_name = role_name
        @method_name = method_name
        @actual = actual
        @expected = expected
      end

      def to_s
        """
        Wrong number of arguments for ##{@method_name} on role double #{@role_name}
        Actual: #{@actual}
        Expected: #{@expected}
        """
      end
    end


  end
end
