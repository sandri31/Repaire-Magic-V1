# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include FlashHelper

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_devise_variables

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[pseudo email password password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[login password])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[pseudo email password password_confirmation current_password])
  end

  def set_devise_variables
    @resource ||= User.new
    @resource_name ||= :user
  end
end
