class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @profile = current_user.profile
    @payments = current_user.payments
    @school = current_user.school
  end
end
