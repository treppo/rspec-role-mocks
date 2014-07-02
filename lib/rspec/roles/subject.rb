module RSpec
  module Roles
    class Subject
      def initialize(given_class, roles)
        @given_class = given_class
        @roles = roles
      end

      def playing_role?(role_name)
        role = @roles.fetch(role_name)
        matching_methods?(role)
      end

      private
      def matching_methods?(role)
        accessor_map = { methods: :method, # class methods
          instance_methods: :instance_method,
          private_instance_methods: :instance_method }

        accessor_map.all? do |method_names, method_objects|
          role_method_names = role.send(method_names, false)

          role_method_names.all? do |name|
            subject_method_names = @given_class.send(method_names, false)

            subject_method_names.include?(name) &&
              role.send(method_objects, name).parameters ==
                @given_class.send(method_objects, name).parameters
          end
        end
      end
    end
  end
end
