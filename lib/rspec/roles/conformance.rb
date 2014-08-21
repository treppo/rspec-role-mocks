require_relative 'subject'
require_relative 'errors'

module RSpec
  module Roles
    module Conformance
      def it_plays_role(role_name)
        it do
          Subject.new(described_class, RSpec::Roles.loaded_roles.fetch(role_name)).playing_role? ||
            raise(NotPlayingRole.new(role_name, described_class))
        end
      end
    end
  end
end
