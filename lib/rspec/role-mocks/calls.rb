module RSpec
  module RoleMocks
    class Calls
      def initialize
        @calls = {}
      end

      def all?(&block)
        @calls.all?(&block)
      end

      def methods
        @calls.keys
      end

      def add(name, args = [])
        @calls[name] = args
      end
    end
  end
end
