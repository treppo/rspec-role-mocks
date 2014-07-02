require 'spec_helper'
require 'rspec/roles/double'

module RSpec
  module Roles
    describe Double do
      describe '#verify' do
        let(:role) { Class.new { def log(message); end } }
        let(:dbl) { Double.new('Logger', role) }

        it 'returns when role defines all recorded method calls' do
          dbl.log

          expect(dbl.verify).to be
        end

        it 'raises an error when the role does not define all called methods' do
          dbl.not_defined

          expect { dbl.verify }.to raise_error
        end

        it 'returns when the expected method call has been made' do
          dbl.add_expectation :log

          dbl.log

          expect(dbl.verify).to be
        end

        it 'raises an error when the expected method call has not been made' do
          dbl.add_expectation :log

          expect { dbl.verify }.to raise_error
        end
      end
    end
  end
end
