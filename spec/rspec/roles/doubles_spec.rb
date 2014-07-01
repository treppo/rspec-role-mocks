require 'spec_helper'
require 'rspec/roles/doubles'

module RSpec
  module Roles
    describe Doubles do
      let(:dbl) { double('Double') }

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
