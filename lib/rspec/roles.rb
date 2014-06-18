require 'rspec/roles/version'
require 'rspec/roles/subject'
require 'rspec/core'

module RSpec
  module Roles
    @@loaded_roles = {}

    def it_plays_role(name)
      it "plays the #{name} role" do
        expect(Subject.new(described_class, @@loaded_roles)).to be_playing_role name
      end
    end

    def self.define(name, &block)
      @@loaded_roles[name] ||= Class.new(&block)
    end
  end
end

RSpec.configure do |rspec|
  rspec.extend RSpec::Roles
  rspec.backtrace_exclusion_patterns << %r(/lib/rspec/roles)
end
