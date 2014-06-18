module RSpec
  module Roles
    class Subject
      def initialize(given_class, roles)
        @given_class = given_class
        @roles = roles
      end

      def playing_role?(role_name)
        role = @roles.fetch(role_name)
        role.instance_methods.all? do |method_name|
          @given_class.method_defined?(method_name)
        end
      end
    end
  end
end
