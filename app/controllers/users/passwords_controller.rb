# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?
    if successfully_sent?(resource)
      session[:password_reset] = true
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    elsif resource.errors[:email].include?("n'a pas été trouvé(e)")
      flash[:alert] = "Email n'a pas été trouvé(e)"
      redirect_to root_path
    else
      respond_with(resource)
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      resource.password = resource_params[:password]
      resource.password_confirmation = resource_params[:password_confirmation]

      if resource.save
        resource.unlock_access! if unlockable?(resource)
        sign_in(resource_name, resource)
        set_flash_message(:notice, :updated) if is_navigational_format?
        respond_with resource, location: after_resetting_password_path_for(resource)
      else
        respond_with resource
      end
    else
      respond_with resource
    end
  end
end
