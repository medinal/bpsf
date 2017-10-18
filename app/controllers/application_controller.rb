class ApplicationController < ActionController::Base
  protect_from_forgery with: :reset_session
  before_action :configure_permitted_parameters, if: :devise_controller?


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :first_name, :last_name, :email, :school_id, :password, :password_confirmation])

  end

end
