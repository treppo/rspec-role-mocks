module RSpec
  module Roles
    class Double
      def initialize(role)
        @called_methods = []
        @expectations = []
        @role = role
      end

      def verify
        @expectations.all? {|m| @called_methods.include?(m) } &&
          @called_methods.all? {|m| @role.instance_methods(false).include?(m) } ||
          raise
      end

      def add_expectation(method_name)
        @expectations << method_name
      end

      def method_missing(method, *args)
        @called_methods << method
      end
    end
  end
end
