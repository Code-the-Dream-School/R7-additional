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
      get customer_path(id: 5000) # an ID that doesn't exist
      expect(response).to redirect_to customers_path
    end
  end

  describe "get new_customer_path" do
    it "renders the :new template" do
      get new_customer_path
      expect(response).to render_template(:new)
    end
  end

  describe "get edit_customer_path" do
    it "renders the :edit template" do
      customer = FactoryBot.create(:customer)
      get edit_customer_path(id: customer.id)
      expect(response).to render_template(:edit)
    end
  end

  describe "post customers_path with valid data" do
    it "saves a new entry and redirects to the show path for the entry" do
      customer_attributes = FactoryBot.attributes_for(:customer)
      expect { 
        post customers_path, params: { customer: customer_attributes }
      }.to change(Customer, :count).by(1)
      expect(response).to redirect_to customer_path(id: Customer.last.id)
    end
  end

  describe "post customers_path with invalid data" do
    it "does not save a new entry or redirect" do
      customer_attributes = FactoryBot.attributes_for(:customer)
      customer_attributes.delete(:first_name)
      expect { 
        post customers_path, params: { customer: customer_attributes }
      }.to_not change(Customer, :count)
      expect(response).to render_template(:new)
    end
  end

  describe "put customer_path with valid data" do
    it "updates an entry and redirects to the show path for the customer" do
      customer = FactoryBot.create(:customer)
      updated_attributes = { first_name: "UpdatedName" }
      put customer_path(id: customer.id), params: { customer: updated_attributes }
      customer.reload
      expect(customer.first_name).to eq("UpdatedName")
      expect(response).to redirect_to customer_path(id: customer.id)
    end
  end

  describe "put customer_path with invalid data" do
    it "does not update the customer record or redirect" do
      customer = FactoryBot.create(:customer)
      invalid_attributes = { first_name: nil }
      put customer_path(id: customer.id), params: { customer: invalid_attributes }
      customer.reload
      expect(customer.first_name).to_not be_nil
      expect(response).to render_template(:edit)
    end
  end

  describe "delete a customer record" do
    it "deletes a customer record" do
      customer = FactoryBot.create(:customer)
      expect {
        delete customer_path(id: customer.id)
      }.to change(Customer, :count).by(-1)
      expect(response).to redirect_to customers_path
    end
  end
end
