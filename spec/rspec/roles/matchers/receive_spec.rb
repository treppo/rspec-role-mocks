require 'spec_helper'
require 'rspec/roles/matchers/receive'

module RSpec
  module Roles
    module Matchers
      describe Receive do
        it 'adds an expected method call to a double' do
          expected_call = :method
          dbl = double('Double')

          expect(dbl).to receive(:add_expectation).with(expected_call)

          described_class.new(expected_call).matches?(dbl)
        end
      end
    end
  end
end
