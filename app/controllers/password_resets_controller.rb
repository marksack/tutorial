class PasswordResetsController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :set_user_for_create, only: [:create]
  before_action :check_expiration, only: [:edit, :update]

  def create
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to root_url
    else
      flash.now[:danger] = 'Email address not found'
      render 'new'
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.reset_password(user_params)
      log_in @user
      flash[:success] = 'Password has been reset.'
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def set_user_for_create
      @user = User.find_by(email: params[:password_reset][:email].downcase)
    end

    def set_user
      @user = User.find_by(email: params[:email])
      redirect_to root_url unless @user&.activated? && @user&.authenticated?(:reset, params[:id])
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = 'Password reset has expired or already been used.'
        redirect_to new_password_reset_url
      end
    end
end
