require 'spec_helper'
require 'rspec/roles/verifier'
require 'rspec/roles/role'

module RSpec
  module Roles
    describe Verifier do
      let(:calls) { double('Calls') }
      let(:expectations) { double('Expectations') }
      let(:role) do
        Role.new 'Logger' do
          def log(arg); end
        end
      end

      def verifier
        described_class.new('Logger', calls, role, expectations)
      end

      describe '#methods_defined' do
        it 'returns when the method is defined on the role' do
          expect(calls).to receive(:methods).and_return [:log]

          expect(verifier.methods_defined).to be
        end

        it 'raises an error when the role does not define all called methods' do
          expect(calls).to receive(:methods).and_return [:log, :write]

          expect { verifier.methods_defined }.to raise_error
        end
      end

      describe '#matching_arity' do
        it 'raises an error when the called method has a different arity' do
          expect(calls).to receive(:all?).and_yield :log, ['arg1', 'arg2']

          expect { verifier.matching_arity }.to raise_error
        end

        it 'returns when the called method has the same arity as in the role' do
          expect(calls).to receive(:all?).and_yield :log, ['arg1']

          expect(verifier.matching_arity).to be
        end
      end

      describe '#providing_expected_arguments' do
        it 'raises an error when not called with the expected arguments' do
          expect(calls).to receive(:all?).and_yield :log, ['argument']
          expect(expectations).to receive(:args).with(:log).and_return ['different']

          expect { verifier.providing_expected_arguments }.to raise_error
        end

        it 'returns when called with the expected arguments' do
          expect(calls).to receive(:all?).and_yield :log, ['argument']
          expect(expectations).to receive(:args).with(:log).and_return ['argument']

          expect(verifier.providing_expected_arguments).to be
        end
      end

      describe '#made_expected_calls' do
        it 'returns when called' do
          expect(calls).to receive(:methods).and_return [:log]
          expect(expectations).to receive(:methods).and_return [:log]

          expect(verifier.made_expected_calls).to be
        end

        it 'raises an error when the expected method call has not been made' do
          expect(calls).to receive(:methods).and_return []
          expect(expectations).to receive(:methods).and_return [:log]

          expect { verifier.made_expected_calls }.to raise_error
        end
      end
    end
  end
end
