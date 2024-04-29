We are going to use a new git branch of your existing customer application for this. While your lesson8 branch is active, create a lesson9 branch, so that it adds to your existing work.

## Additional Gem Files for RSpec Testing

We will do automated testing for the customer-order application. Edit the Gemfile. Add the following lines to the :development, :test section of the Gemfile:

```
gem 'rspec-rails'
gem 'factory_bot_rails'
gem 'faker'
gem 'rails-controller-testing'
gem 'rexml'
```

These gems will be used to enable testing. After saving your Gemfile, run:

```
bundle install
```

## More Setup

Enter the following command to complete the setup of rspec:

```
bin/rails generate rspec:install
```

Then enter this command to set up the test database:

```
bin/rails db:migrate db:test:prepare
```

Then, enter these commands to set up the shells of test classes for the customer model and customers controller:

```
bin/rails generate rspec:model Customer
bin/rails generate rspec:request Customers

```

## Generated Files

The shells of two test case files have been generated. These are:

```
./spec/models/customer_spec.rb
./spec/requests/customers_spec.rb

```

You can now run rspec, using the command:

```
bundle exec rspec
```

But as the test cases have not been written, it won’t test anything. Edit spec/models/customer\_spec.rb, copying the following code.

```
require 'rails_helper'
RSpec.describe Customer, type: :model do
  subject { Customer.new(first_name: "Jack", last_name: "Smith", phone: "8889995678", email: "jsmith@sample.com" )}
  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end
  it "is not valid without a first_name" do
    subject.first_name=nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a last_name" do
    subject.last_name=nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a phone number"
  it "is not valid without an email"
  it "is not valid if the phone number is not 10 chars"
  it "is not valid if the phone number is not all digits"
  it "is not valid if the email address doesn't have a @"
  it "returns the correct full_name" do
    expect(subject.full_name).to eq("Jack Smith")
  end
end

```

## RSpec Model Test Code Explained

Rspec introduces some domain specific language. The Rspec.describe do/end block describes what the type of object, in this case a model class, should do. We start out with a subject, which is a piece of sample data, in this case a Customer object. We have several “it” blocks, which document the expected results of the test case. An “it” block without a do/end is a test case that is “pending” meaning the test hasn’t been written yet.

We “expect” certain results, so each of the test cases has one or more expected results. There are expect matchers, which are documented here: <https://rspec.info/features/3-12/rspec-expectations/built-in-matchers/>

## Run rspec Again

Now the customer\_spec.rb tests will run. You will see that some results are printed out, indicating how many tests passed (green), failed (red), or are pending (yellow).

Edit ./app/models/customer.rb and comment out this line:

```
validates :first_name, presence: true, format: { with: /\A[a-z\-' ]+\z/i }
```

Then save the file and run rspec again. You will see that a test fails. The model is not validating the presence of the first\_name, and the test reports this. Edit customer.rb again, and uncomment the line. You will see that the test again passes.

## Complete the Customer Model Test

Now add to spec/models/customer\_spec.rb. There are a number of “it” statements without do/end blocks. Add them. Each block should set up a test using the subject, and should have an appropriate expect statement. Then run rspec again. You should get all tests to pass, without any pending tests.

## Request Testing

For request testing, we will use FactoryBot. This acts as a factory for sample data. We will also use Faker. This gem generates plausible values for sample data. Let’s start with the factory. Edit the file ./spec/factories/customers.rb so that it reads as follows:

```
require 'faker'
FactoryBot.define do
  factory :customer do |f|
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.phone { Faker::Number.number(digits: 10) }
    f.email { Faker::Internet.email }
  end
end

```

This provides a means of generating as many sample customer entries as we want.

## Editing ./spec/requests/customers\_spec.rb

Copy the following code into the file:

```
require 'rails_helper'
RSpec.describe "CustomersControllers", type: :request do
  describe "get customers_path" do
    it "renders the index view" do
      FactoryBot.create_list(:customer, 10)
      get customers_path
      expect(response).to render_template(:index)
    end
  end
  describe "get customer_path" do
    it "renders the :show template" do
      customer = FactoryBot.create(:customer)
      get customer_path(id: customer.id)
      expect(response).to render_template(:show)
    end
    it "redirects to the index path if the customer id is invalid" do
      get customer_path(id: 5000) #an ID that doesn't exist
      expect(response).to redirect_to customers_path
    end
  end
describe "get new_customer_path" do
    it "renders the :new template"
  end
  describe "get edit_customer_path" do
    it "renders the :edit template"
  end
  describe "post customers_path with valid data" do
    it "saves a new entry and redirects to the show path for the entry" do
      customer_attributes = FactoryBot.attributes_for(:customer)
      expect { post customers_path, params: {customer: customer_attributes}
    }.to change(Customer, :count)
      expect(response).to redirect_to customer_path(id: Customer.last.id)
    end
  end
  describe "post customers_path with invalid data" do
    it "does not save a new entry or redirect" do
      customer_attributes = FactoryBot.attributes_for(:customer)
      customer_attributes.delete(:first_name)
      expect { post customers_path, params: {customer: customer_attributes}
    }.to_not change(Customer, :count)
      expect(response).to render_template(:new)
    end
  end
  describe "put customer_path with valid data" do
    it "updates an entry and redirects to the show path for the customer"
  end
  describe "put customer_path with invalid data" do
    it "does not update the customer record or redirect"
  end
  describe "delete a customer record" do
    it "deletes a customer record"
  end
end

```

## Now Run rspec Again

You will find that there are more tests, all passing (green), with some pending (yellow). If you look at the code you will see several new types of expect matchers. A post of valid data should change the number of Customer records, and should result in a redirect to a particular path. A post of invalid data should not change the number of customer records, and should result in a render, not a redirect. The HTTP status code for a render is 200 meaning OK. You can check the status code by checking response.status. 

For post and put requests, you must test both valid and invalid data to make sure both paths through the code work.

Edit ./app/controllers/customers\_controller.rb . Comment out the line that starts with rescue\_from and run rspec again. You will find that there is a test failure. So, that rescue\_from line is needed. Uncomment it.

## What Are We Testing?

Request testing tests each of the routes you have specified in config/routes.rb. You can see those routes by typing:

```
bin/rails routes
```

Request testing tests each of the methods you have in the controller, which methods pointed to by the routes. To know what the test should do, you can look at the code in the controller (except that, in test driven development, you create the tests before you create the controller).

## Tips on Request Testing

To test the edit, put, and delete routes, you need to specify a route to an existing entry. So, you have to create that entry first. You use the factory. Then you pass the id of the customer entry you create to the path. A put request is used to update an entry. So, here is an example of a test of a put request with invalid data:

```
  describe "put customer_path with invalid data" do
    it "does not update the customer record or redirect"
 do
      customer = FactoryBot.create(:customer)
      put customer_path(customer.id), params: {customer: {phone: "123"}}
      customer.reload
      expect(customer.phone).not_to eq("123")
      expect(response).to render_template(:edit) 
    end
  end

```

Note the use of customer.reload. The operation is attempting to change the database. It will not change the copy of the customer object you have in memory. You need to do the reload to copy values from the database into the customer object in memory. In this case, the database value is not supposed to change, because the data is invalid.

## Complete the Customer Request Testing

Add to spec/requests/customers\_spec.rb so as to complete the pending test cases, those being the “it” blocks with do/end or expect statements.

## Submitting your work

Add, commit, and push your lesson9 branch to github.  Then create the pull request for this assignment.