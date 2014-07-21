module RSpec
  module Roles
    module Matchers
      class Receive
        def initialize(method_name)
          @method_name = method_name
          @arguments = []
          @return_value = nil
        end

        def matches?(double)
          double.add_expectation(@method_name, @arguments)
          double.add_return_value(@method_name, @return_value) if @return_value
          double
        end

        def with(*args)
          @arguments = args
          self
        end

        def and_return(return_value)
          @return_value = return_value
          self
        end
      end
    end
  end
end
