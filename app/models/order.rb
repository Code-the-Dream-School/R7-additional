class Order < ApplicationRecord
  belongs_to :customer

  validates :product_name, presence: true
  validates :product_count, presence: true
  validates :customer, presence: true
end
