require 'rails_helper'

RSpec.describe Order, type: :model do
  subject { Order.new( product_name: "gears", product_count: 7, customer: FactoryBot.create(:customer))}
  it "is valid with valid atributes" do
    expect(subject).to be_valid
  end
  it "is not valid without product name" do
    subject.product_name = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without product count" do
    subject.product_count = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without customer" do
    subject.customer = nil
    expect(subject).to_not be_valid
  end
  #pending "add some examples to (or delete) #{__FILE__}"
end
