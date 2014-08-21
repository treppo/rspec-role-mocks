module RSpec
  module Roles
    class Subject
      def initialize(subject, role)
        @subject = InconsistencyWrapper.new(subject)
        @role = InconsistencyWrapper.new(role)
      end

      def playing_role?
        implementing_all_methods? && matching_parameters?
      end

      private

      def method_types
        [:class, :instance, :private_instance]
      end

      def implementing_all_methods?
        method_types.all? do |type|
          not_implemented = @role.method_names(type) - @subject.method_names(type)
          not_implemented.empty?
        end
      end

      def matching_parameters?
        method_types.all? do |type|
          @role.method_names(type).all? do |role_method_name|
            @role.method(type, role_method_name).parameters ==
              @subject.method(type, role_method_name).parameters
          end
        end
      end

      class InconsistencyWrapper
        def initialize(cl)
          @cl = cl
        end

        def method_names(type)
          self.send("#{type}_methods".to_sym)
        end

        def method(type, name)
          self.send("#{type}_method".to_sym, name)
        end

        def instance_methods
          @cl.instance_methods(false)
        end

        def instance_method(name)
          @cl.instance_method(name)
        end

        def class_methods
          @cl.methods(false)
        end

        def class_method(name)
          @cl.method(name)
        end

        def private_instance_methods
          @cl.private_instance_methods(false)
        end

        def private_instance_method(name)
          @cl.instance_method(name)
        end
      end
    end
  end
end
