module RSpec
  def self.define_role(name, &block)
    RSpec::Roles.loaded_roles[name] = Class.new(&block)
  end
end

