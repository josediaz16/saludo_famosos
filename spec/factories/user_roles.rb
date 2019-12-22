FactoryBot.define do
  factory :user_role do
    association :user, factory: :user

    trait(:celebrity) do
      association :role, factory: :role, name: 'celebrity'
    end

    trait(:fan) do
      association :role, factory: :role, name: 'fan'
    end

    trait(:admin) do
      association :role, factory: :role, name: 'admin'
    end
  end
end
