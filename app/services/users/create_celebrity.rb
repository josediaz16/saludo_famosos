module Users
  class CreateCelebrity
    include AppConfig::Transaction.new(container: Celebrities::Container)

    use_db_transaction

    step :create_user, with: "ops.create_celebrity_user"
    tee  :add_role,    with: "ops.add_role"
    step :create_specific

    def create_specific(input)
      data = input[:celebrity]
        .to_h
        .merge(user_id: input[:model].id)

      Celebrities::Create.(data).fmap { input }
    end

  end
end
