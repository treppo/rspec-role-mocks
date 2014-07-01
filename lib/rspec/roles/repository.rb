class RoleNotRequiredError < NameError
end

module RSpec
  module Roles
    class Repository
      def initialize
        @roles = {}
      end

      def fetch(role_name)
        definition = @roles[role_name]

        if definition.nil?
          raise RoleNotRequiredError, "The role #{role_name} has not been required"
        end

        definition
      end

      def add!(role_name, definition)
        @roles[role_name] = definition
      end
    end
  end
end
