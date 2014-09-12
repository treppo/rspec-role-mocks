module RSpec
  module RoleMocks
    module Adapter
      def setup_mocks_for_rspec
        # called before each example is run
      end

      def verify_mocks_for_rspec
        # called after each example is run
        RSpec::RoleMocks::Doubles.verify
      end

      def teardown_mocks_for_rspec
        # called after verify_mocks_for_rspec
        RSpec::RoleMocks::Doubles.reset!
      end
    end
  end
end


