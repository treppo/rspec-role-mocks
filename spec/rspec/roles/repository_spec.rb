require 'spec_helper'
require 'rspec/roles/repository'

module RSpec
  module Roles
    describe Repository do
      ROLE_NAME = 'Logger'
      let(:repo) { described_class.new }
      let(:definition) { Class.new }

      it 'stores role definition' do
        repo.add(ROLE_NAME, definition)

        expect(repo.fetch(ROLE_NAME)).to equal definition
      end

      it 'raises an exception, when the role is not defined' do
        expect{ repo.fetch('NotDefined') }.to raise_error RoleNotRequiredError, "The role NotDefined has not been required"
      end
    end
  end
end
