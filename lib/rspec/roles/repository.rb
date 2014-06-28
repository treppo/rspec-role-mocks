class RoleNotRequiredError < NameError
end

module RSpec
  module Roles
    class Repository
      def initialize
        @roles = {}
      end

      def [](role_name)
        definition = @roles[role_name]

        if definition.nil?
          raise RoleNotRequiredError, "The role #{role_name} has not been required"
        end

        definition
      end

      def []=(role_name, definition)
        @roles[role_name] = definition
      end

      alias_method :fetch, :[]
    end
  end
end
