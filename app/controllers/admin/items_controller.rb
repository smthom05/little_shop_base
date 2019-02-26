class Admin::ItemsController < Admin::BaseController
  def index
    @merchant = User.find_by(email: params[:slug])
    @items = @merchant.items
    render :'/merchants/items/index'
  end

  def new
    @merchant = User.find_by(email: params[:slug])
    @item = Item.new
    @form_path = [:admin, @merchant, @item]

    render "/merchants/items/new"
  end

  def edit
    @merchant = User.find_by(email: params[:slug])
    @item = Item.find_by(slug: params[:slug])
    @form_path = [:admin, @merchant, @item]

    render "/merchants/items/edit"
  end
end
