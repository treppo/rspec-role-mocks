require 'spec_helper'
require 'rspec/role-mocks/matchers/receive'

module RSpec
  module RoleMocks
    module Matchers
      describe Receive do
        describe '#matches?' do
          let(:dbl) { double('Double') }
          let(:expected_call) { :method }
          subject(:receive_matcher) { described_class.new(expected_call) }

          it 'adds an expected method call to a double' do
            empty_arguments = []
            ret_val = nil

            expect(dbl).to receive(:add_expectation).with(expected_call, empty_arguments, ret_val)

            receive_matcher.matches?(dbl)
          end

          describe '#with' do
            it 'adds the expected method call and the arguments to the double' do
              expected_arguments = ['arg1', 'arg2']
              ret_val = nil

              expect(dbl).to receive(:add_expectation).with(expected_call, expected_arguments, ret_val)

              receive_matcher.with(*expected_arguments).matches?(dbl)
            end
          end

          describe '#and_return' do
            it 'adds a return value to the expectation in the double' do
              return_value = 'Brando'
              args = []

              expect(dbl).to receive(:add_expectation).with(expected_call, args, return_value)

              receive_matcher.and_return(return_value).matches?(dbl)
            end
          end
        end
      end
    end
  end
end
