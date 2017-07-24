class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout :determine_layout
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_filter :flash_to_headers

  protected

  def determine_layout
    current_user.nil? ? 'devise' : 'application'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :profile_pic])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :auto_verify, :profile_pic])
  end

  def flash_to_headers
    return unless request.xhr?
    return if flash.empty?

    response.headers['X-Message'] = flash_message
    response.headers["X-Message-Type"] = flash_type.to_s

    flash.discard # don't want the flash to appear when you reload page
  end

  private

  def flash_message
    [:error, :warning, :notice, :info].each do |type|
      return flash[type] unless flash[type].blank?
    end
  end

  def flash_type
    [:error, :warning, :notice, :info].each do |type|
      return type unless flash[type].blank?
    end
  end

end
