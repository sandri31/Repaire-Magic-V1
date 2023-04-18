class SessionsController < Devise::SessionsController
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)

    respond_to do |format|
      format.html { super }
      format.turbo_stream do
        @password_reset = session.delete(:password_reset)
        if !@password_reset
          flash.now[:alert] = "Mauvais email ou mot de passe."
        end
        render turbo_stream: turbo_stream.replace(:flash_messages, partial: "partials/flash", locals: { flash: flash })
      end
    end
  end

  def create
    puts "DEBUG: auth_options are: #{auth_options.inspect}" # DEBUG temporary
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end
end
