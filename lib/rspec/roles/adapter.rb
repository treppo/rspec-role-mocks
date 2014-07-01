module RSpec
  module Roles
    module Adapter
      def setup_mocks_for_rspec
        # called before each example is run
      end

      def verify_mocks_for_rspec
        # called after each example is run
        RSpec::Roles::Doubles.verify
      end

      def teardown_mocks_for_rspec
        # called after verify_mocks_for_rspec
        RSpec::Roles::Doubles.reset!
      end
    end
  end
end


