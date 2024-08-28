class OrdersController < ApplicationController
    before_action :set_order, only: [:show, :edit, :update, :destroy]
  
    # GET /orders
    def index
      @orders = Order.all
    end
  
    # GET /orders/:id
    def show
      # @order is already set by the before_action :set_order
    end
  
    # GET /orders/new
    def new
      @order = Order.new
    end
  
    # GET /orders/:id/edit
    def edit
      # @order is already set by the before_action :set_order
    end
  
    # POST /orders
    def create
      @order = Order.new(order_params)
  
      if @order.save
        redirect_to @order, notice: 'Order was successfully created.'
      else
        render :new
      end
    end
  
    # PATCH/PUT /orders/:id
    def update
      if @order.update(order_params)
        redirect_to @order, notice: 'Order was successfully updated.'
      else
        render :edit
      end
    end
  
    # DELETE /orders/:id
    def destroy
      @order.destroy
      redirect_to orders_url, notice: 'Order was successfully deleted.'
    end
  
    private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end
  
    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:customer_id, :product_id, :quantity, :total_price, :status)
    end
  end
  