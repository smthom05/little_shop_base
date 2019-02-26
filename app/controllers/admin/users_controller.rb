class Admin::UsersController < Admin::BaseController
  def index
    @users = User.where(role: 0).order(:name)
  end

  def show
    @user = User.find_by(email: params[:slug])
    if @user.merchant?
      redirect_to admin_merchant_path(@user)
    else
      render :'/users/show'
    end
  end

  def edit
    @user = User.find_by(email: params[:slug])
    @form_path = [:admin, @user]
    render :'/users/edit'
  end

  def update
    @user = User.find_by(email: params[:slug])
    if @user.update(user_params)
      flash[:success] = "Profile has been updated"
      redirect_to admin_user_path(@user)
    end
  end

  def upgrade
    user = User.find_by(email: params[:slug])
    user.role = :merchant
    user.save
    redirect_to admin_users_path
  end

  def disable
    user = User.find_by(email: params[:slug])
    set_active_flag(user, false)
    redirect_to admin_users_path
  end

  def enable
    user = User.find_by(email: params[:slug])
    set_active_flag(user, true)
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :address, :city, :state, :zip, :password)
  end

  def set_active_flag(user, active_flag)
    user.active = active_flag
    user.save
  end
end
