require 'spec_helper'
require 'rspec/roles/doubles'
require 'rspec/roles/double'

module RSpec
  module Roles
    describe Doubles do
      let(:role) { Class.new { def log(message); end } }
      let(:dbl) { Double.new('Logger', role) }

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
          verifier = double('DoubleVerifier')
          described_class.register(dbl)

          expect(verifier).to receive(:verify).with(dbl)

          described_class.verify(verifier)
        end
      end
    end
  end
end
