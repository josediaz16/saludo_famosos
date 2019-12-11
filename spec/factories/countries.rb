FactoryBot.define do
  factory :country do
    name          { "Colombia" }
    code_iso      { "CO" }
    country_code  { "+57" }
    currency      { "COP" }
  end
end
