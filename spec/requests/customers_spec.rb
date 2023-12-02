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
    it "renders the :new template" do
      get customer_path(:new)
      expect(response).to render_template(:new)
    end
  end
  describe "get edit_customer_path" do
    it "renders the :edit template" do
      customer = FactoryBot.create(:customer)
      get edit_customer_path(customer.id)
      expect(response).to render_template(:edit)
    end
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
    it "updates an entry and redirects to the show path for the customer" do
      # generate a hash of valid attributes for a customer object.
      customer_attributes = FactoryBot.attributes_for(:customer)
      # create and save a customer object in the database.
      customer = FactoryBot.create(:customer)
      # send a PUT request to the customer_path with the customer's id and the new attributes as parameters.
      put customer_path(customer.id), params: {customer: customer_attributes}
      customer.reload # will reflect the changes made by the PUT request on database
      # check that the customer's last name attribute is updated to match the new value in the parameters hash.
      expect(customer.last_name).to eq(customer_attributes[:last_name])
      # check that the response is redirect to the customer's show page.
      expect(response).to redirect_to(customer_path(customer))
    end 
  end
  describe "put customer_path with invalid data" do
    it "does not update the customer record or redirect" do
      # generate a hash of valid attributes for a customer object.
      customer_attributes = FactoryBot.attributes_for(:customer)
      # create and save a customer object in the database
      customer = FactoryBot.create(:customer)
      # checking if the customer.reload.attributes value has changed after the put customer_path action
      expect { put customer_path(customer), params: {customer: customer_attributes}
      }.to change { customer.reload.attributes }
      # using the be_redirect matcher, which checks if the response is redirect
      expect(response).to be_redirect
    end
  end
  describe "delete a customer record" do
    it "deletes a customer record" do
      # generate a hash of valid attributes for a customer object.
      customer_attributes = FactoryBot.attributes_for(:customer)
      # create and save a customer object in the database
      customer = FactoryBot.create(:customer)
      # remove the :customer key from the attributes hash, since it is not needed for the delete action
      customer_attributes.delete(:customer) 
      expect {
        # execute the delete action with the customer’s id and the attributes hash as parameters, and wrap it in a block.
        delete customer_path(customer.id), params: {customer: customer_attributes}
      }.to change(Customer, :count).by(-1) # check the delete action reduces the customers in the database by one
    end
  end
end