FactoryBot.define do
  factory :code do
    discount { build(:discount) }
    value { Forgery::Basic.password }
    status { "available" }
  end
end
