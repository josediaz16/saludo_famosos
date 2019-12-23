module Celebrities
  class Container
    extend Dry::Container::Mixin

    namespace "ops" do
      register "create_celebrity_user", Users::Create
      register "create_fan_user", Users::Create
      register "add_role", Users::Ops::AddRole.new
      register "add_fan_role", Users::Ops::AddRole.new(role_name: "fan")
    end
  end
end
