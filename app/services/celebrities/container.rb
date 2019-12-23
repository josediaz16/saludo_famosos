module Celebrities
  class Container
    extend Dry::Container::Mixin

    namespace "ops" do
      register "create_celebrity_user", Users::Create
      register "add_role", Users::Ops::AddRole.new
    end
  end
end
