class UsersController < ApplicationController
  def show
    if current_user
      @user = current_user
      @school = School.find(@user.id)
      @start = @user.profile.started_teaching
    
    else
      redirect_to login_path
    end
  end
end
