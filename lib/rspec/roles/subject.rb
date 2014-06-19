module RSpec
  module Roles
    class Subject
      def initialize(given_class, roles)
        @given_class = given_class
        @roles = roles
      end

      def playing_role?(role_name)
        role = @roles.fetch(role_name)
        methods_implemented?(role) && constructor_implemented?(role)
      end

      private
      def methods_implemented?(role)
        role.instance_methods(false).all? do |method_name|
          @given_class.method_defined?(method_name)
        end
      end

      def constructor_implemented?(role)
        return defines_initialize?(@given_class) if defines_initialize?(role)
        true
      end

      def defines_initialize?(klass)
        ! klass.instance_method(:initialize).to_s.include?('BasicObject')
      end
    end
  end
end
