require_relative 'subject'
require_relative 'errors'

module RSpec
  module RoleMocks
    module Conformance
      def it_plays_role(role_name)
        it do
          Subject.new(described_class, RSpec::RoleMocks.loaded_roles.fetch(role_name)).playing_role? ||
            raise(NotPlayingRole.new(role_name, described_class))
        end
      end
    end
  end
end
