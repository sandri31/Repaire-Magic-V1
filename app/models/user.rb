require 'bcrypt'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :lockable, :omniauthable, omniauth_providers: %i[google_oauth2 github]

  validates :pseudo, uniqueness: { case_sensitive: false }, allow_blank: true,
                     length: { minimum: 3, maximum: 20 }

  attr_accessor :login

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email || "#{auth.extra.raw_info.login}@example.com"
      user.password = Devise.friendly_token[0, 20]
      user.skip_confirmation!
      user.full_name = auth.info.name
      user.avatar_url = auth.info.image

      if auth.info.email
        user.pseudo = auth.info.email.split('@').first
      elsif auth.provider == 'github' && auth.extra.raw_info.login
        user.pseudo = auth.extra.raw_info.login
      end

      Rails.logger.error "User validation errors: #{user.errors.full_messages.join(', ')}" unless user.save
    end
  end

  def valid_password?(password)
    bcrypt_password = BCrypt::Password.new(encrypted_password)
    bcrypt_password.is_password?(password)
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    puts "DEBUG: login value is: #{login.inspect}" # DEBUG temporary

    if login
      query_conditions = ['lower(pseudo) = :value OR lower(email) = :value', { value: login.strip.downcase }]
      puts "DEBUG: query_conditions are: #{query_conditions.inspect}" # DEBUG temporary
      where(conditions).where(query_conditions).first
    elsif conditions.has_key?(:pseudo) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end
end
