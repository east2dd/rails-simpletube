class Admin::BaseController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_filter :prepare_for_mobile
  protect_from_forgery with: :exception
  layout "admin"
  
  def is_mobile_device?
    request.user_agent =~ /Mobile|webOS/
  end

  def prepare_for_mobile
    prepend_view_path Rails.root + 'app' + 'views_mobile' if is_mobile_device?
  end

  private
  def user_not_authorized
    flash[:danger] = "You are not authorized to perform this action."
    redirect_to :back
  end
end