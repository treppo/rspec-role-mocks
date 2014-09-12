require 'spec_helper'
require 'rspec/role-mocks/doubles'
require 'rspec/role-mocks/double'

module RSpec
  module RoleMocks
    describe Doubles do
      let(:role) { Class.new { def log(message); end } }
      let(:dbl) { double }

      after do
        described_class.reset!
      end

      describe '.register' do
        it 'returns the passed in double' do
          expect(described_class.register(dbl)).to equal(dbl)
        end
      end

      describe '.verify' do
        it 'verifies all registered doubles' do
          described_class.register(dbl)

          expect(dbl).to receive(:verify)

          described_class.verify
        end
      end
    end
  end
end
