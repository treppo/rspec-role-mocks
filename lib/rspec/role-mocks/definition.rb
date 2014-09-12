require_relative 'role'

module RSpec
  def self.define_role(name, &block)
    RSpec::RoleMocks.loaded_roles.add!(name, RoleMocks::Role.new(name, &block))
  end
end
