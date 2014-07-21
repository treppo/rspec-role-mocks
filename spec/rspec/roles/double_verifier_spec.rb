require 'spec_helper'
require 'rspec/roles/double'
require 'rspec/roles/double_verifier'

module RSpec
  module Roles
    describe DoubleVerifier do
      describe '#verify(dbl)' do
        let(:role) { Class.new { def log(message); end } }
        let(:dbl) { Double.new('Logger', role) }
        let(:verifier) { described_class }

        it 'raises an error when the role does not define all called methods' do
          dbl.not_defined

          expect { verifier.verify(dbl) }.to raise_error
        end

        it 'raises an error when the called method has a different arity' do
          dbl.log

          expect { verifier.verify(dbl) }.to raise_error
        end

        context 'when role defines the recorded method call' do
          context 'when the expected method call has been made' do
            it 'returns when called with the expected arguments' do
              dbl.add_expectation(:log, ['message'])

              dbl.log('message')

              expect(verifier.verify(dbl)).to be
            end

            it 'raises an error when not called with the expected arguments' do
              dbl.add_expectation(:log, ['message'])

              dbl.log('other_message')

              expect { verifier.verify(dbl) }.to raise_error
            end
          end
        end

        it 'raises an error when the expected method call has not been made' do
          dbl.add_expectation(:log, [])

          expect { verifier.verify(dbl) }.to raise_error
        end
      end
    end
  end
end
