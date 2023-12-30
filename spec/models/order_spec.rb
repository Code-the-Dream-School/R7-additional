require 'rails_helper'

RSpec.describe Order, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  subject { Order.new( product_name: "gears", product_count: 7, customer: FactoryBot.create(:customer))}
end
