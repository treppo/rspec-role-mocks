module RSpec
  module Roles
    module Matchers
      class Receive
        def initialize(method_name, opts = {})
          @method_name = method_name
          @args = opts[:args] || []
          @ret_val = opts[:ret_val]
        end

        def matches?(double)
          double.add_expectation(@method_name, @args)
          double.add_return_value(@method_name, @ret_val) if @ret_val
          double
        end

        def with(*args)
          create(args: args, ret_val: @ret_val)
        end

        def and_return(ret_val)
          create(ret_val: ret_val, args: @args)
        end

        private

        def create(opts)
          self.class.new(@method_name, {args: @args, ret_val: @ret_val}.merge(opts))
        end
      end
    end
  end
end
