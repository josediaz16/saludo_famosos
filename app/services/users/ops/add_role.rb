module Users
  module Ops
    class AddRole
      include AppConfig::Import["role_name"]

      def call(input)
        role = Role.find_by(name: role_name)
        UserRole.create(role_id: role.id, user_id: input[:model].id)
      end
    end
  end
end
