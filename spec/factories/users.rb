FactoryBot.define do
  factory :user do
    name      { Faker::Name.name }
    email     { Faker::Internet.email }
    password  { "holifluviper"}
    phone     { "3212343213" }

    transient do
      with_country { true }
    end

    after(:build) do |user, evaluator|
      user.country ||= if evaluator.with_country
        Country.last || create(:country)
      end
    end
  end
end
