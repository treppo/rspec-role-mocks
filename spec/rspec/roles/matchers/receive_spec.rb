require 'spec_helper'
require 'rspec/roles/matchers/receive'

module RSpec
  module Roles
    module Matchers
      describe Receive do
        describe '#matches?' do
          let(:dbl) { double('Double') }
          let(:expected_call) { :method }
          subject(:receive_matcher) { described_class.new(expected_call) }

          it 'adds an expected method call to a double' do
            empty_arguments = []

            expect(dbl).to receive(:add_expectation).with(expected_call, empty_arguments)

            receive_matcher.matches?(dbl)
          end

          describe '#with' do
            it 'adds the expected method call and the arguments to the double' do
              expected_arguments = ['arg1', 'arg2']

              expect(dbl).to receive(:add_expectation).with(expected_call, expected_arguments)

              receive_matcher.with(*expected_arguments).matches?(dbl)
            end
          end

          describe '#and_return' do
            it 'adds a return value to the double' do
              return_value = 'Brando'

              allow(dbl).to receive(:add_expectation)
              expect(dbl).to receive(:add_return_value).with(expected_call, return_value)

              receive_matcher.and_return(return_value).matches?(dbl)
            end
          end
        end
      end
    end
  end
end
