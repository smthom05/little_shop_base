class Merchants::DiscountsController < ApplicationController
  before_action :require_merchant

  def index
    @merchant = current_user
    @discounts = @merchant.discounts
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
    @discount = Discount.new
    @form_path = [:dashboard, @discount]
  end

  def edit
    @discount = Discount.find(params[:id])
    @form_path = [:dashboard, @discount]
  end

  def create
    @merchant = current_user
    dp = discount_params

    @discount = @merchant.discounts.new(dp)

    if @discount.save
      flash[:success] = "New Discount Added!"
      redirect_to dashboard_discounts_path
    else
      @form_path = [:dashboard, @discount]
      render :new
    end
  end

  def update
    @merchant = current_user
    @discount = Discount.find(params[:id])

    dp = discount_params
    @discount.update(dp)
    if @discount.save
      flash[:success] = "Successfully Updated Discount Number: #{@discount.id}!"
      redirect_to dashboard_discount_path(@discount)
    else
      @form_path = [:dashboard, @discount]
      render :edit
    end
  end

  private

  def discount_params
    params.require(:discount).permit(:discount_amount, :discount_quantity)
  end
end
