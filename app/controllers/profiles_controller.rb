class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: [:edit, :update]
  before_action :set_next

  def new
    @profile = Profile.new
  end

  def edit
    if current_user.stripe_token? and @next
      Stripe.api_key = ENV["stripe_api_key"]
      customer = Stripe::Customer.retrieve(current_user.stripe_token)
      @card = customer.sources.retrieve(customer.default_source)
    end
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user = current_user
    if @profile.save
      if @next
        redirect_to @next, notice: 'You successfully created your profile!'
      else
        redirect_to user_path, notice: 'You successfully created your profile!'
      end
    else
      render :new
    end
  end

  def update
    if @profile.update(profile_params)
      if @next
        redirect_to @next, notice: 'Profile was successfully updated.'
      else
        redirect_to user_path, notice: 'Profile was successfully updated.'
      end
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
                                    :relationship, :started_teaching)
  end

  def set_next
    @next = params['next'] if params['next']
  end


end
