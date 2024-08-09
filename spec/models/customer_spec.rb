require 'rails_helper'
RSpec.describe Customer, type: :model do
  subject { Customer.new(first_name: "Jack", last_name: "Smith", phone: "8889995679", email: "jsmith@sample.com" )}
  
  it "is valid with valid attributes" do 
      expect(subject).to be_valid
  end
  it "is not valid without a first_name" do
    subject.first_name=nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a last_name" do
    subject.last_name = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a phone number" do
    subject.phone = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without an email" do
    subject.email = nil
    expect(subject).to_not be_valid
  end
  it "is not valid if the phone number is not 10 chars" do
    # it's work's but I used if and this is not good practice
    # if subject.phone.length != 10 
    #   expect(subject).to_not be_valid
    # end
    # another variant
    expect(subject.phone.length).to eq(10)
  end
  it "is not valid if the phone number is not all digits" do
    # try to find solution with a tr method, we can find many solutions, but I know that you know why ;)
    # idea - to take every number and replace to nil and it leaves nothing we will pass
    # it's work's but I used if and this is not good practice
    # some_phone_string = subject.phone.tr("1234567890","")
    # if some_phone_string.length > 0
    #   expect(subject).to_not be_valid
    # end
    # 
    # another variant
    expect(subject.phone.tr("1234567890","")).to eq("")
  end
  it "is not valid if the email address doesn't have a @" do
    # it's work's but I used if and this is not good practice
    # if subject.phone.index("@") == 0 
    #   expect(subject).to_not be_valid
    # end
    # 
    #anothe variant
    expect(subject.email).to include("@")
  end
  it "returns the correct full_name" do
    expect(subject.full_name).to eq("Jack Smith")
  end
end