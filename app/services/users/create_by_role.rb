module Users
  UserOpts = {
    fan: CreateFan.new,
    celebrity: CreateCelebrity.new(create_specific: Fns::Monads::Right)
  }

  CreateByRole = -> input do
    role = input[:role] || 'celebrity'
    UserOpts[role.to_sym].(input)
  end
end
