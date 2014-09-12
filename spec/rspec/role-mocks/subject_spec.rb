require 'spec_helper'
require 'rspec/role-mocks/subject'
require 'rspec/role-mocks/role'

module RSpec
  module RoleMocks
    describe Subject do
      let(:role_name) { 'Logger' }

      context 'matching instance methods defined by role' do
        let(:role) do
          Role.new 'Name' do
            def log(message); end
            def set; end
          end
        end

        it 'is true if the subject is implementing all' do
          given_class = Class.new do
            def set; end
            def log(message); end
          end

          subj = described_class.new(given_class, role)

          expect(subj).to be_playing_role
        end

        it 'is false if the subject is not implementing all' do
          given_class = Class.new do
            def log(message); end
          end

          subj = described_class.new(given_class, role)

          expect(subj).not_to be_playing_role
        end
      end

      context 'matching class methods defined by role' do
        let(:role) do
          role = Role.new 'Name' do
            def self.create(opts); end
            def self.check; end
          end
        end

        it 'is true if the subject is implementing all' do
          given_class = Class.new do
            def self.create(opts); end
            def self.check; end
          end

          subj = described_class.new(given_class, role)

          expect(subj).to be_playing_role
        end

        it 'is false if the subject is not implementing all' do
          given_class = Class.new do
            def self.check; end
          end

          subj = described_class.new(given_class, role)

          expect(subj).not_to be_playing_role
        end
      end

      context 'matching constructor defined by role' do
        let(:role) do
          Role.new 'Name' do
            def initialize(message); end
            def log; end
          end
        end

        it 'is true if the subject is implementing it' do
          given_class = Class.new do
            def initialize(message); end
            def log; end
          end

          subj = described_class.new(given_class, role)

          expect(subj).to be_playing_role
        end

        it 'is false if the subject is not implementing it' do
          given_class = Class.new do
            def log; end
          end

          subj = described_class.new(given_class, role)

          expect(subj).not_to be_playing_role
        end
      end

      context 'matching method parameters' do
        let(:role) do
          Role.new 'Name' do
            def meth(required, required2, *rest, &block); end
          end
        end

        it 'is true if the subject method has the parameters' do
          given_class = Class.new do
            def meth(required, required2, *rest, &block); end
          end

          subj = described_class.new(given_class, role)

          expect(subj).to be_playing_role
        end

        it 'is false if the arity off' do
          given_class = Class.new do
            def meth(required); end
          end

          subj = described_class.new(given_class, role)

          expect(subj).not_to be_playing_role
        end

        it 'is false if the parameters have different names' do
          given_class = Class.new do
            def meth(required, required_other, *rest, &block); end
          end

          subj = described_class.new(given_class, role)

          expect(subj).not_to be_playing_role
        end
      end
    end
  end
end
