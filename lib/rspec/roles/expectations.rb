module RSpec
  module Roles
    class Expectations
      def initialize
        @expectations = {}
      end

      def add(method_name, args, ret_val)
        @expectations[method_name] = {args: args, rv: ret_val}
      end

      def methods
        @expectations.keys
      end

      def args(method)
        @expectations[method][:args]
      end

      def ret_val(method)
        @expectations[method] && @expectations[method][:rv]
      end
    end
  end
end
