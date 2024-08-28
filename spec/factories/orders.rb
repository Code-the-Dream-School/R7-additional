FactoryBot.define do
  factory :order do
    product_name { Faker::Lorem.word }
    product_count { Faker::Number.number(digits: 3).to_i }
    association :customer
  end
end
