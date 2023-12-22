class CustomersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  before_action :set_customer, only: %i[ show edit update destroy ]

  # GET /customers or /customers.json
  def index
    @customers = Customer.all
  end

  # GET /customers/1 or /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers or /customers.json
  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      flash.notice = "The customer record was created successfully."
      redirect_to @customer
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /customers/1 or /customers/1.json
  def update
    if @customer.update(customer_params)
      flash.notice = "The customer record was updated successfully."
      redirect_to @customer
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy_with_orders
    if (@customer.orders.exists?)
      @customer.orders.destroy_all
    end
    @customer.destroy
    flash.notice = "The customer record and all related order records were successfully deleted."
    redirect_to customers_url
  end

  # DELETE /customers/1 or /customers/1.json

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      #debugger
      @customer = Customer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_params
      params.require(:customer).permit(:first_name, :last_name, :phone, :email)
    end
    def catch_not_found(e)
      Rails.logger.debug("We had a not found exception.")
      flash.alert = e.to_s
      redirect_to customers_path
    end 
end
