require 'spec_helper'
require 'rspec/roles/double'

module RSpec
  module Roles
    describe Double do
      describe '#verify' do
        let(:val) { 'Brundo' }
        let(:role) { Class.new { def log(message) end } }
        let(:dbl) { Double.new('Logger', role) }

        it 'returns a predefined return value' do
          dbl.add_return_value(:log, val)

          expect(dbl.log).to equal(val)
        end

        it 'records every method call' do
          dbl.log('message')

          expect(dbl.called_methods).to include :log
          expect(dbl.calls[:log]).to eq ['message']
        end

        context 'with allowed method calls and return values' do
          let(:dbl) { Double.new('Logger', role, log: val) }

          it 'returns initialized return value for allowed method call' do
            expect(dbl.log).to equal(val)
          end

          it 'does not record calls for allowed methods' do
            dbl.log

            expect(dbl.called_methods).not_to include :log
          end
        end
      end
    end
  end
end
