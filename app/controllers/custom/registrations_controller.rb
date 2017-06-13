class Custom::RegistrationsController < Devise::RegistrationsController
  def new
    super # no customization, simply call the devise implementation
  end

  def create
    super
    
    @admins = AdminUser.all
    if @user.save
      p "hello"
        @admins.each do |admin|
          AdminNewuserJob.new.async.perform(@user, admin)
        end
    end
  end

  def update
    super # no customization, simply call the devise implementation 
  end

end