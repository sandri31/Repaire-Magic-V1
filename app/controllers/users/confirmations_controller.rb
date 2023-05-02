# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      sign_in(resource) # Logs the user in automatically
      set_flash_message(:notice, :confirmed)
      respond_with_navigational(resource) { redirect_to after_confirmation_path_for(resource_name, resource) }
    elsif resource.confirmed?
      set_flash_message(:alert, :already_confirmed)
      redirect_to root_path
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity) { render :new }
    end
  end

  def create
    self.resource = resource_class.find_or_initialize_with_error_by(:unconfirmed_email, resource_params[:email])
    if resource.persisted? && resource.confirmed?
      flash[:alert] = 'Le compte est déjà confirmé. Veuillez essayer de vous connecter.'
      redirect_to root_path
    else
      self.resource = resource_class.send_confirmation_instructions(resource_params)
      yield resource if block_given?

      if successfully_sent?(resource)
        session[:confirmation_sent] = true
        respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
      elsif resource.errors[:email].include?("n'a pas été trouvé(e)")
        flash[:alert] = "Email n'a pas été trouvé(e)"
        redirect_to root_path
      else
        flash[:alert] = resource.errors.full_messages.join(', ')
        redirect_to root_path
      end
    end
  end

  protected

  def after_confirmation_path_for(_resource_name, _resource)
    root_path
  end

  def after_resending_confirmation_instructions_path_for(_resource_name)
    root_path
  end
end
