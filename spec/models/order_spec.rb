# spec/models/order_spec.rb
require 'rails_helper'

RSpec.describe Order, type: :model do
  before do
    @customer = Customer.create!(
      first_name: 'John',
      last_name: 'Doe',
      phone: '1234567890',         # Provide a valid phone number
      email: 'john.doe@example.com' # Provide a valid email
    )
  end

  context 'validations' do
    it 'is valid with valid attributes' do
      order = Order.new(product_name: 'Widget', product_count: 10, customer: @customer)
      expect(order).to be_valid
    end

    it 'is invalid without a product_name' do
      order = Order.new(product_name: nil, product_count: 10, customer: @customer)
      expect(order).not_to be_valid
      expect(order.errors[:product_name]).to include("can't be blank")
    end

    it 'is invalid without a product_count' do
      order = Order.new(product_name: 'Widget', product_count: nil, customer: @customer)
      expect(order).not_to be_valid
      expect(order.errors[:product_count]).to include("can't be blank")
    end

    it 'is invalid with a non-integer product_count' do
      order = Order.new(product_name: 'Widget', product_count: 'ten', customer: @customer)
      expect(order).not_to be_valid
      expect(order.errors[:product_count]).to include('is not a number')
    end

    it 'is invalid with a product_count of zero or less' do
      order = Order.new(product_name: 'Widget', product_count: 0, customer: @customer)
      expect(order).not_to be_valid
      expect(order.errors[:product_count]).to include('must be greater than 0')
    end

    it 'is invalid without a customer' do
      order = Order.new(product_name: 'Widget', product_count: 10, customer: nil)
      expect(order).not_to be_valid
      expect(order.errors[:customer]).to include("must exist")
    end
  end
end
