FactoryBot.define do
  factory :fan do
    association :user, factory: :user_fan
  end
end
