module Users
  class CreateFan
    include AppConfig::Transaction.new(container: Celebrities::Container)

    step :create_user, with: "ops.create_fan_user"
    tee  :add_role,    with: "ops.add_fan_role"
    tee  :create_specific

    def create_specific(input)
      data = input[:fan]
        .to_h
        .merge(user_id: input[:model].id)

      Fans::Create.(data).fmap { input }
    end

  end
end
