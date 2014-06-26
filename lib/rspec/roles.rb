require 'rspec/roles/version'
require 'rspec/roles/definition'
require 'rspec/roles/conformance'
require 'rspec/core'

module RSpec
  module Roles
    @@loaded_roles = {}

    def self.loaded_roles
      @@loaded_roles
    end
  end
end

RSpec.configure do |rspec|
  rspec.extend RSpec::Roles::Conformance
  rspec.backtrace_exclusion_patterns << %r(/lib/rspec/roles)
end
