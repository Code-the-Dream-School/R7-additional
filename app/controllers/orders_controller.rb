class OrdersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  before_action :set_order, only: %i[ show edit update destroy ]

  # Define a method for displaying a list of all orders
  def index
    @orders = Order.all
  end

  # Define a method for displaying a specific order
  def show
  end

  # Define a method for returning an HTML form for creating a new order
  def new
    @order = Order.new
    @customers = Customer.all
  end

  # Define a method for returning an HTML form for editing an order
  def edit
  end

  # Define a method for creating a new order
  def create
    @customers = Customer.all
    @order = Order.new(order_params)
    if @order.save
      flash.notice = "The order was successfully created."
      redirect_to @order
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Define a method for updating an order
  def update
    if @order.update(order_params)
      flash.notice = "Order was successfully updated."
      redirect_to @order
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Define a method for deleting an order
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to order_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # Define a private method for setting the order parameters
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:customer, :customer_id, :product_name, :product_count)
    end
    def catch_not_found(e)
      Rails.logger.debug("We had a not found exception.")
      flash.alert = e.to_s
      redirect_to order_path
    end 
end