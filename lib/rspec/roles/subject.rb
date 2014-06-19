module RSpec
  module Roles
    class Subject
      def initialize(given_class, roles)
        @given_class = given_class
        @roles = roles
      end

      def playing_role?(role_name)
        role = @roles.fetch(role_name)
        class_methods_implemented?(role) &&
          instance_methods_implemented?(role) &&
          constructor_implemented?(role)
      end

      private
      def class_methods_implemented?(role)
        role.methods(false).all? do |method_name|
          @given_class.methods(false).include?(method_name)
        end
      end

      def instance_methods_implemented?(role)
        role.instance_methods(false).all? do |method_name|
          @given_class.instance_methods(false).include?(method_name)
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
