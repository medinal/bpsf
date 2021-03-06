class Custom::RegistrationsController < Devise::RegistrationsController
  def new
    super # no customization, simply call the devise implementation
  end

  def create
    def after_sign_up_path_for(resource)
      new_user_profiles_path
    end

    super
    @admins = AdminUser.all
    if @user.save
        WelcomeEmailJob.new.async.perform(@user)
        @admins.each do |admin|
          AdminNewuserJob.new.async.perform(@user, admin)
        end
        flash[:notice] = "Thanks for signing up! Please create a profile for your account"
    end
  end

  def update
    def after_update_path_for(resource)
      user_path + "?current=account-label"
    end

    super # no customization, simply call the devise implementation 
  end

end