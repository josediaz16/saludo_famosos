FactoryBot.define do
  factory :message_request do
    from     { Faker::Name.name }
    to       { Faker::Name.name }
    phone_to { Faker::Internet.email }
    brief    { Faker::Lorem.paragraph }
    association :celebrity
  end
end
