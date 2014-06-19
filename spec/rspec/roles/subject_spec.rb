require 'spec_helper'
require 'rspec/roles/subject'

module RSpec
  module Roles
    describe Subject do
      describe '#playing_role?' do
        ROLE_NAME = 'Logger'

        it 'is true if the subject is implementing all methods defined in the role' do
          role = define_role do
            def log(message); end
            def set; end
          end
          roles_repo = fake_roles_repo(role)
          given_class = Class.new do
            def set; end
            def log(message); end
          end

          subj = described_class.new(given_class, roles_repo)

          expect(subj).to be_playing_role ROLE_NAME
        end

        it 'is false if the subject is not implementing all methods defined in the role' do
          role = define_role do
            def log(message); end
            def set; end
          end
          roles_repo = fake_roles_repo(role)
          given_class = Class.new do
            def log(message); end
          end

          subj = described_class.new(given_class, roles_repo)

          expect(subj).not_to be_playing_role ROLE_NAME
        end

        it 'is even false if the subject is not implementing the initialize method defined in the role' do
          role = define_role do
            def initialize(message); end
            def log; end
          end
          roles_repo = fake_roles_repo(role)
          given_class = Class.new do
            def log; end
          end

          subj = described_class.new(given_class, roles_repo)

          expect(subj).not_to be_playing_role ROLE_NAME
        end

        def define_role(&block)
          Class.new(&block)
        end

        def fake_roles_repo(role)
          {ROLE_NAME => role}
        end
      end
    end
  end
end
