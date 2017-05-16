class UsersController < ApplicationController
  def show
    if current_user
      @user = current_user
      @profile = current_user.profile
      @payments = current_user.payments
    else
      redirect_to login_path
    end
  end
end
