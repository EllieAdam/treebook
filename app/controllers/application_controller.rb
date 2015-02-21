class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  add_flash_types :error, :success

  protect_from_forgery with: :exception

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name << :profile_image << :remote_profile_image_url << :remove_profile_image << :profile_image_cache_id
    devise_parameter_sanitizer.for(:account_update) << :name << :profile_image << :remote_profile_image_url << :remove_profile_image << :profile_image_cache_id
  end
end
