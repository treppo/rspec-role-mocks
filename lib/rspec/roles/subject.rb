module RSpec
  module Roles
    class Subject
      def initialize(given_class, roles)
        @given_class = given_class
        @roles = roles
      end

      def playing_role?(role_name)
        methods_implemented? @roles.fetch(role_name)
      end

      private
      def methods_implemented?(role)
        [:methods, # returns class methods
        :instance_methods,
        :private_instance_methods].all? do |method_type|
          role.send(method_type, false).all? do |method_name|
            @given_class.send(method_type, false).include?(method_name)
          end
        end
      end
    end
  end
end
