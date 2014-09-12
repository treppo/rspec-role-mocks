module RSpec
  module RoleMocks
    class Role
      attr_reader :__name

      def initialize(name, &definition)
        @definitian = Class.new(&definition)
        @__name = name
      end

      def method_names(type)
        send("#{type}_methods".to_sym)
      end

      def method(type, name)
        send("#{type}_method".to_sym, name)
      end

      def instance_methods
        @definitian.instance_methods(false)
      end

      def instance_method(name)
        @definitian.instance_method(name)
      end

      def instance_method_arity(name)
        @definitian.instance_method(name).arity
      end

      def class_methods
        @definitian.methods(false)
      end

      def class_method(name)
        @definitian.method(name)
      end

      def private_instance_methods
        @definitian.private_instance_methods(false)
      end

      def private_instance_method(name)
        @definitian.instance_method(name)
      end
    end
  end
end
