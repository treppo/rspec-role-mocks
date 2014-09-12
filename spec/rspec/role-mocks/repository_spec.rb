require 'spec_helper'
require 'rspec/role-mocks/repository'

module RSpec
  module RoleMocks
    describe Repository do
      let(:role_name) { 'Logger' }
      let(:repo) { described_class.new }
      let(:definition) { Class.new }

      it 'stores role definition' do
        repo.add!(role_name, definition)

        expect(repo.fetch(role_name)).to equal definition
      end

      it 'raises an exception, when the role is not defined' do
        expect { repo.fetch('NotDefined') }.to raise_error RoleNotRequiredError, "The role NotDefined has not been required"
      end
    end
  end
end
