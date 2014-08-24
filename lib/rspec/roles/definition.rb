require_relative 'role'

module RSpec
  def self.define_role(name, &block)
    RSpec::Roles.loaded_roles.add!(name, Roles::Role.new(name, &block))
  end
end
