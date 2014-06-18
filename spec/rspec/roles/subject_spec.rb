require 'spec_helper'
require 'rspec/roles/subject'
require 'rspec/roles'

module RSpec
  module Roles
    describe Subject do
      describe '#playing_role?' do
        ROLE_NAME = 'Logger'

        it 'is true if the given class is playing the defined role' do
          given_class = Class.new do
            def log(message); end
          end

          expect(described_class.new(given_class, roles)).to be_playing_role ROLE_NAME
        end

        it 'is false if the given class is not playing the defined role' do
          given_class = Class.new

          expect(described_class.new(given_class, roles)).not_to be_playing_role ROLE_NAME
        end

        def roles
          role = RSpec::Roles.define ROLE_NAME do
            def log(message); end
          end

          {'Logger' => role}
        end
      end
    end
  end
end
