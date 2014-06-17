require 'rspec/roles/version'
require 'rspec/core'

module RSpec
  module Roles
    def plays_role name
    end

    def self.define name
    end
  end
end

RSpec.configure do |rspec|
  rspec.extend RSpec::Roles
  rspec.backtrace_exclusion_patterns << %r(/lib/rspec/roles)
end
