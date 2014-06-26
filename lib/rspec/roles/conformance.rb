require 'rspec/roles/subject'

module RSpec
  module Roles
    module Conformance
      def it_plays_role(name)
        it "plays the #{name} role" do
          expect(Subject.new(described_class, RSpec::Roles.loaded_roles)).to be_playing_role name
        end
      end
    end
  end
end
