require_relative 'subject'
require_relative 'errors'

module RSpec
  module Roles
    module Conformance
      def it_plays_role(name)
        it do
          Subject.new(described_class, RSpec::Roles.loaded_roles).playing_role?(name) ||
            raise(NotPlayingRole.new(name, described_class))
        end
      end
    end
  end
end
