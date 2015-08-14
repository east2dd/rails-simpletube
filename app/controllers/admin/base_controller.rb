class Admin::BaseController < ActionController::Base
  before_filter :prepare_for_mobile
  protect_from_forgery with: :exception
  layout "admin"
  
  def is_mobile_device?
    request.user_agent =~ /Mobile|webOS/
  end

  def prepare_for_mobile
    prepend_view_path Rails.root + 'app' + 'views_mobile' if is_mobile_device?
  end
end