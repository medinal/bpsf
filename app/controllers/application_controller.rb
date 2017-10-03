class ApplicationController < ActionController::Base
   protect_from_forgery  with: :exception
  skip_before_filter :verify_authenticity_token, if: -> { controller_name == 'sessions' && action_name == 'create' }
  before_action :configure_permitted_parameters, if: :devise_controller?


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :first_name, :last_name, :email, :school_id, :password, :password_confirmation])

  end

end
