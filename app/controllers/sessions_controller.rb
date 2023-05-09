# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)

    respond_to do |format|
      format.html { super }
      format.turbo_stream do
        @password_reset = session.delete(:password_reset)
        flash.now[:alert] = 'Email et/ou mot de passe incorrect(s).' unless flash[:alert] || @password_reset
        render turbo_stream: turbo_stream.replace(:flash_messages, partial: 'partials/flash', locals: { flash: })
      end
    end
  end

  def create
    self.resource = resource_class.new(sign_in_params)
    user = User.find_for_database_authentication(login: params[:user][:login])

    respond_to do |format|
      format.html do
        process_login(user)
      end
      format.turbo_stream do
        process_login_turbo_stream(user)
      end
    end
  end

  private

  def process_login(user)
    if user_exists_and_unconfirmed?(params[:user][:login])
      flash.now[:alert] = 'Vous devez confirmer votre adresse e-mail avant de continuer.'
      render :new
    elsif user
      authenticate_and_sign_in_user(user)
    else
      flash.now[:alert] = if User.find_for_database_authentication(login: params[:user][:login]).nil?
                            "Email/Pseudo n'existe pas."
                          else
                            'Mot de passe incorrect.'
                          end
      render :new
    end
  end

  def process_login_turbo_stream(user)
    if user_exists_and_unconfirmed?(params[:user][:login])
      flash.now[:alert] = 'Vous devez confirmer votre adresse e-mail avant de continuer.'
      render turbo_stream: turbo_stream.replace(:flash_messages, partial: 'partials/flash', locals: { flash: })
    elsif user
      authenticate_and_sign_in_user(user, turbo_stream: true)
    else
      flash.now[:alert] = if User.find_for_database_authentication(login: params[:user][:login]).nil?
                            "Email/Pseudo n'existe pas."
                          else
                            'Mot de passe incorrect.'
                          end
      render turbo_stream: turbo_stream.replace(:flash_messages, partial: 'partials/flash', locals: { flash: })
    end
  end

  def authenticate_and_sign_in_user(_user, turbo_stream: false)
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    if turbo_stream
      respond_to do |format|
        format.turbo_stream { redirect_to after_sign_in_path_for(resource), format: :turbo_stream }
      end
    else
      respond_to do |format|
        format.html { redirect_to after_sign_in_path_for(resource) }
      end
    end
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end

  def unconfirmed
    flash.now[:alert] = 'Vous devez confirmer votre adresse e-mail avant de pouvoir vous connecter.'
    render :new
  end

  def user_exists_and_unconfirmed?(email)
    user = User.find_by(email:)
    user && !user.confirmed?
  end
end
