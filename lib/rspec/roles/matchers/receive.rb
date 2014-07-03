module RSpec
  module Roles
    module Matchers
      class Receive
        def initialize(method_name)
          @method_name = method_name
          @arguments = []
        end

        def matches?(double)
          double.add_expectation(@method_name, @arguments)
        end

        def with(*args)
          @arguments = args
          self
        end
      end
    end
  end
end
