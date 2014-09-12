require 'spec_helper'
require 'rspec/role-mocks/double'
require 'rspec/role-mocks/role'

module RSpec
  module RoleMocks
    describe Double do
      def create_dbl(opts = {})
        role = Role.new 'Logger' do
          def log(message) end
        end

        described_class.new('Logger', role, opts)
      end

      it 'verifies calls, expectations and role defintions' do
        verifier = double('Verifier')
        dbl = create_dbl(verifier: verifier)

        expect(verifier).to receive(:made_expected_calls).and_return(true)
        expect(verifier).to receive(:methods_defined).and_return(true)
        expect(verifier).to receive(:matching_arity).and_return(true)
        expect(verifier).to receive(:providing_expected_arguments).and_return(true)

        dbl.verify
      end

      it 'returns initialized return value for allowed method call' do
        ret_val = 'Mile Me Deaf'
        dbl = create_dbl(allowed: {log: ret_val})

        expect(dbl.log).to equal(ret_val)
      end

      it 'can receive expectations' do
        ret_val = 'Mile Me Deaf'
        expectations = double('Expectations')
        dbl = create_dbl(expectations: expectations)

        expect(expectations).to receive(:add).with :log, ['arg'], ret_val

        dbl.add_expectation(:log, ['arg'], ret_val)
      end

      describe 'expectations and calls' do
        let(:dbl) { create_dbl(expectations: expectations, calls: calls) }
        let(:calls) { double('Calls') }
        let(:expectations) { double('Expectations') }

        it 'records method calls and arguments' do
          allow(expectations).to receive :ret_val
          expect(calls).to receive(:add).with(:log, ['message'])

          dbl.log 'message'
        end

        it 'returns predefined value' do
          expected = 'Fekete'
          allow(expectations).to receive(:ret_val).with(:log).and_return expected
          allow(calls).to receive :add

          actual = dbl.log

          expect(actual).to equal expected
        end
      end
    end
  end
end
