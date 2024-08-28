require 'faker'
FactoryBot.define do
  factory :order do
    product_name { Faker::Commerce.product_name }
    product_count { Faker::Number.between(from: 1, to: 100) }  # Ensures product_count is a realistic number
    association :customer  # Associates the order with a customer
  end
end
