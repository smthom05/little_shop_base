class Admin::MerchantsController < Admin::BaseController
  def show
    @merchant = User.find_by(slug: params[:slug])
    if @merchant.default?
      redirect_to admin_user_path(@merchant.slug)
    else
      render :'/merchants/show'
    end
  end

  def downgrade
    user = User.find_by(slug: params[:user_slug])
    user.role = :default
    user.save
    redirect_to merchants_path
  end

  def enable
    set_user_active(true)
  end

  def disable
    set_user_active(false)
  end

  private

  def set_user_active(state)
    user = User.find_by(slug: params[:slug])
    user.active = state
    user.save
    redirect_to merchants_path
  end
end
