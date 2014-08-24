require 'spec_helper'
require 'rspec/roles/double'
require 'rspec/roles/double_verifier'

module RSpec
  module Roles
    describe DoubleVerifier do
      let(:role) { Class.new { def log(message); end } }
      let(:dbl) { Double.new('Logger', role) }
      let(:verifier) { described_class.new(dbl) }

      describe '#methods_defined' do
        it 'returns when the method is defined on the role' do
          dbl.log

          expect(verifier.methods_defined).to be
        end

        it 'raises an error when the role does not define all called methods' do
          dbl.not_defined

          expect { verifier.methods_defined(dbl) }.to raise_error
        end
      end

      describe '#matching_arity' do
        it 'raises an error when the called method has a different arity' do
          dbl.log

          expect { verifier.matching_arity }.to raise_error
        end

        it 'returns when the called method has the same arity as in the role' do
          dbl.log('message')

          expect(verifier.matching_arity).to be
        end
      end

      describe '#providing_expected_arguments' do
        it 'raises an error when not called with the expected arguments' do
          dbl.add_expectation(:log, ['message'])

          dbl.log('other_message')

          expect { verifier.providing_expected_arguments }.to raise_error
        end

        it 'returns when called with the expected arguments' do
          dbl.add_expectation(:log, ['message'])

          dbl.log('message')

          expect(verifier.providing_expected_arguments).to be
        end
      end

      describe '#made_expected_calls' do
        it 'returns when called' do
          dbl.add_expectation(:log, ['message'])

          dbl.log('message')

          expect(verifier.made_expected_calls).to be
        end

        it 'raises an error when the expected method call has not been made' do
          dbl.add_expectation(:log, [])

          expect { verifier.made_expected_calls }.to raise_error
        end
      end
    end
  end
end
