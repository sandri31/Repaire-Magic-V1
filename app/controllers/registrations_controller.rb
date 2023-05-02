# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_to do |format|
        format.html { render :new }
        format.turbo_stream do
          flash.now[:alert] = resource.errors.full_messages.each_with_index.map do |msg, index|
            "#{msg}#{' Et ' if index < resource.errors.count - 1}"
          end.join
          render turbo_stream: turbo_stream.replace(:flash_messages, partial: 'partials/flash',
                                                                     locals: { flash: })
        end
      end
    end
  end

  def update
    self.resource = resource_class.find(send(:"current_#{resource_name}").id)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?

    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in(resource, scope: resource_name) if sign_in_after_change_password?

      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length

      filtered_errors = resource.errors.dup
      filtered_errors.delete(:current_password)

      flash[:alert] = filtered_errors.full_messages.join(', ')

      flash[:alert] += " #{resource.errors[:current_password].join(', ')}" if resource.errors[:current_password].any?

      respond_with resource
    end
  end

  def update_resource(resource, params)
    if resource.provider == 'google_oauth2' || resource.provider == 'github'
      params.delete('current_password')
      resource.password = params['password'] if params['password'].present?

      return false if User.exists?(email: params['email'])

      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end
end
