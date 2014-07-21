require 'spec_helper'
require 'rspec/roles/double'

module RSpec
  module Roles
    describe Double do
      describe '#verify' do
        let(:role) { Class.new { def log(message); end } }
        let(:dbl) { Double.new('Logger', role) }

        it 'raises an error when the role does not define all called methods' do
          dbl.not_defined

          expect { dbl.verify }.to raise_error
        end

        it 'raises an error when the called method has a different arity' do
          dbl.log

          expect { dbl.verify }.to raise_error
        end

        context 'when role defines the recorded method call' do
          context 'when the expected method call has been made' do
            it 'returns when called with the expected arguments' do
              dbl.add_expectation(:log, ['message'])

              dbl.log('message')

              expect(dbl.verify).to be
            end

            it 'raises an error when not called with the expected arguments' do
              dbl.add_expectation(:log, ['message'])

              dbl.log('other_message')

              expect { dbl.verify }.to raise_error
            end
          end
        end

        it 'raises an error when the expected method call has not been made' do
          dbl.add_expectation(:log, [])

          expect { dbl.verify }.to raise_error
        end

        it 'returns a predefined return value' do
          return_value = 'Brando'

          dbl.add_return_value(:log, return_value)

          expect(dbl.log).to equal(return_value)
        end
      end
    end
  end
end
