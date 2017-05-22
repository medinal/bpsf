class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: [:edit, :update]

  def new
    @profile = Profile.new
  end

  def edit
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user = current_user
    if @profile.save
      redirect_to user_path(current_user), notice: 'You successfully created your profile!'
    else
      render :new
    end
  end

  def update
    if @profile.update(profile_params)
      redirect_to user_path(current_user), notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_profile
    if current_user.profile
      @profile = current_user.profile
    else
      redirect_to new_user_profile_path
    end
  end

  def profile_params
    params.require(:profile).permit(:about, :address, :city, :position, :state,
                                    :zipcode, :grade, :home_phone, :work_phone,
                                    :subject, :relationship, :started_teaching)
  end


end
