class Merchants::OrderItemsController < ApplicationController
  before_action :merchant_or_admin

  def update
    oi = OrderItem.find(params[:id])
    oi.fulfill
    if oi.order.order_items.where(fulfilled: false).empty?
      oi.order.status = :completed
      oi.order.save
    end
    flash[:success] = "You have successfully fulfilled an item"
    if current_admin?
      redirect_to admin_merchant_path(oi.item.user.slug)
    else
      redirect_to dashboard_order_path(oi.order)
    end
  end
end
