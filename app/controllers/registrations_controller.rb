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
          flash.now[:alert] = resource.errors.full_messages.each_with_index.map { |msg, index| "#{msg}#{' Et ' if index < resource.errors.count - 1}" }.join
          render turbo_stream: turbo_stream.replace(:flash_messages, partial: "partials/flash", locals: { flash: flash })
        end
      end
    end
  end
end
