class Order < ApplicationRecord
  # Define a foreign key constraint on the customer_id column
  belongs_to :customer
  # Validate that a product_name, product_count, and customer are present
  validates :product_name, :product_count, :customer, presence: true

  # Validate that the customer_id actually corresponds to a real customer record
  
end