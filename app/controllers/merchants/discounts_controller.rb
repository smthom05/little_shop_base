class Merchants::DiscountsController < ApplicationController
  before_action :require_merchant

  def index
    @merchant = current_user
    @discounts = @merchant.discounts
  end

  def new
    @discount = Discount.new
    @form_path = [:dashboard, @discount]
  end
end
