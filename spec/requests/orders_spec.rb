# spec/requests/orders_spec.rb
require 'rails_helper'

RSpec.describe "Orders", type: :request do
  describe "GET /orders" do
    it "renders the index view" do
      FactoryBot.create_list(:order, 10)
      get orders_path
      expect(response).to render_template(:index)
    end
  end

  describe "GET /orders/:id" do
    it "renders the show template" do
      order = FactoryBot.create(:order)
      get order_path(id: order.id)
      expect(response).to render_template(:show)
    end

    it "redirects to the index path if the order id is invalid" do
      get order_path(id: 5000) # an ID that doesn't exist
      expect(response).to redirect_to orders_path
    end
  end

  describe "GET /orders/new" do
    it "renders the new template" do
      get new_order_path
      expect(response).to render_template(:new)
    end
  end

  describe "GET /orders/:id/edit" do
    it "renders the edit template" do
      order = FactoryBot.create(:order)
      get edit_order_path(id: order.id)
      expect(response).to render_template(:edit)
    end
  end

  describe "POST /orders" do
    context "with valid data" do
      it "creates a new order and redirects to the show path for the order" do
        customer = FactoryBot.create(:customer)  # Ensure you have a valid customer
        order_attributes = FactoryBot.attributes_for(:order, customer_id: customer.id)
        expect { 
          post orders_path, params: { order: order_attributes }
        }.to change(Order, :count).by(1)
        expect(response).to redirect_to order_path(id: Order.last.id)
      end
    end

    context "with invalid data" do
      it "does not create a new order and renders the new template" do
        customer = FactoryBot.create(:customer)  # Ensure you have a valid customer
        order_attributes = FactoryBot.attributes_for(:order, customer_id: customer.id)
        order_attributes.delete(:product_name)  # Make product_name nil or invalid
        expect { 
          post orders_path, params: { order: order_attributes }
        }.to_not change(Order, :count)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PUT /orders/:id" do
    context "with valid data" do
      it "updates the order and redirects to the show path for the order" do
        order = FactoryBot.create(:order)
        updated_attributes = { product_name: "UpdatedProduct" }
        put order_path(id: order.id), params: { order: updated_attributes }
        order.reload
        expect(order.product_name).to eq("UpdatedProduct")
        expect(response).to redirect_to order_path(id: order.id)
      end
    end

    context "with invalid data" do
      it "does not update the order and renders the edit template" do
        order = FactoryBot.create(:order)
        invalid_attributes = { product_name: nil }
        put order_path(id: order.id), params: { order: invalid_attributes }
        order.reload
        expect(order.product_name).to_not be_nil
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE /orders/:id" do
    it "deletes the order and redirects to the index path" do
      order = FactoryBot.create(:order)
      expect {
        delete order_path(id: order.id)
      }.to change(Order, :count).by(-1)
      expect(response).to redirect_to orders_path
    end
  end
end
