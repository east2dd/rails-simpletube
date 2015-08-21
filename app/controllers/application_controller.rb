class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate
  before_filter :set_tags 
  before_filter :prepare_for_mobile
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "wetube" && password == "wetube"
    end
  end

  def is_mobile_device?
    request.user_agent =~ /Mobile|webOS/
  end

  def set_tags
    @tags ||= Video.tag_counts_on(:tags)
  end

  def prepare_for_mobile
    prepend_view_path Rails.root + 'app' + 'views_mobile' if is_mobile_device?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u|
      u.permit(:first_name, :last_name, :password, :password_confirmation, :current_password, :avatar, :remove_avatar) 
    }

    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :first_name, :last_name, :password, :password_confirmation, :avatar, :remove_avatar)
    end
  end
end