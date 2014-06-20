require 'spec_helper'
require 'rspec/roles/subject'

module RSpec
  module Roles
    describe Subject do
      describe '#playing_role?' do
        ROLE_NAME = 'Logger'

        let(:roles_repo) { fake_roles_repo(role) }

        context 'role defines instance methods' do
          let(:role) do
            define_role do
              def log(message); end
              def set; end
            end
          end

          it 'is true if the subject is implementing all' do
            given_class = Class.new do
              def set; end
              def log(message); end
            end

            subj = described_class.new(given_class, roles_repo)

            expect(subj).to be_playing_role ROLE_NAME
          end

          it 'is false if the subject is not implementing all' do
            given_class = Class.new do
              def log(message); end
            end

            subj = described_class.new(given_class, roles_repo)

            expect(subj).not_to be_playing_role ROLE_NAME
          end
        end

        context 'role defines class methods' do
          let(:role) do
            role = define_role do
              def self.create(opts); end
              def self.check; end
            end
          end

          it 'is true if the subject is implementing all' do
            given_class = Class.new do
              def self.create(opts); end
              def self.check; end
            end

            subj = described_class.new(given_class, roles_repo)

            expect(subj).to be_playing_role ROLE_NAME
          end

          it 'is false if the subject is not implementing all' do
            given_class = Class.new do
              def self.check; end
            end

            subj = described_class.new(given_class, roles_repo)

            expect(subj).not_to be_playing_role ROLE_NAME
          end
        end

        context 'role defines the constructor' do
          let(:role) do
            define_role do
              def initialize(message); end
              def log; end
            end
          end

          it 'is true if the subject is implementing it' do
            given_class = Class.new do
              def initialize(message); end
              def log; end
            end

            subj = described_class.new(given_class, roles_repo)

            expect(subj).to be_playing_role ROLE_NAME
          end

          it 'is false if the subject is not implementing it' do
            given_class = Class.new do
              def log; end
            end

            subj = described_class.new(given_class, roles_repo)

            expect(subj).not_to be_playing_role ROLE_NAME
          end
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
