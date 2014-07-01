module RSpec
  module Roles
    module Matchers
      class Receive
        def initialize(method_name)
          @method_name = method_name
        end

        def matches?(double)
          double.add_expectation(@method_name)
        end
      end
    end
  end
end
