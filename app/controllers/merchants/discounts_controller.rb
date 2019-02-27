class Merchants::DiscountsController < ApplicationController
  before_action :require_merchant
  before_action :set_merchant

  def index
    @discounts = Discount.where(user_id: @merchant.id)
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


  def destroy
    @discount = Discount.find(params[:id])
    flash[:success] = "Successfully Deleted Discount Number: #{@discount.id}!"
    @discount.destroy
    redirect_to dashboard_discounts_path
  end

  def switch_discount_type
    @merchant.change_discount_type
    Discount.discount_deleter(@merchant)

    redirect_to dashboard_discounts_path
  end

  private

  def set_merchant
    @merchant = current_user
  end

  def discount_params
    params.require(:discount).permit(:discount_amount, :discount_quantity)
  end
end
