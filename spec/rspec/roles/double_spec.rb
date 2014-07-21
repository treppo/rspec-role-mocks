require 'spec_helper'
require 'rspec/roles/double'

module RSpec
  module Roles
    describe Double do
      describe '#verify' do
        let(:role) { Class.new { def log(message); end } }
        let(:dbl) { Double.new('Logger', role) }

        it 'returns a predefined return value' do
          return_value = 'Brando'

          dbl.add_return_value(:log, return_value)

          expect(dbl.log).to equal(return_value)
        end
      end
    end
  end
end
