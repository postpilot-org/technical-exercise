FactoryBot.define do
  factory :discount do
    name { Forgery::Name.industry }
    kind { "uploaded" }
  end
end
