# frozen_string_literal: true

require 'bcrypt'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :lockable, :omniauthable, omniauth_providers: %i[google_oauth2 github]

  validates :email, uniqueness: true, presence: true, length: { maximum: 255 }
  validates :pseudo, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 20 },
                     format: { with: /\A[\w\-_\À-ÿ]+\z/,
                               message: 'ne doit contenir aucun espace ni caractères spéciaux' }
  validate :unique_stripped_pseudo
  before_validation :strip_pseudo

  attr_accessor :login

  def self.from_omniauth(access_token)
    user_email = access_token.info.email || "github-#{access_token.uid}@example.com"

    user = User.where(email: user_email).first
    user ||= User.create(pseudo: access_token.info.name,
                         email: user_email,
                         password: Devise.friendly_token[0, 20],
                         confirmed_at: Time.now)
    user.full_name = access_token.info.name
    user.avatar_url = access_token.info.image
    user.uid = access_token.uid
    user.provider = access_token.provider
    user.confirmed_at = Time.now if user.confirmed_at.nil?
    user.save(validate: false)

    user
  end

  def valid_password?(password)
    bcrypt_password = BCrypt::Password.new(encrypted_password)
    bcrypt_password.is_password?(password)
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    # puts "DEBUG: login value is: #{login.inspect}" # DEBUG temporary

    if login
      query_conditions = ['lower(pseudo) = :value OR lower(email) = :value', { value: login.strip.downcase }]
      # puts "DEBUG: query_conditions are: #{query_conditions.inspect}" # DEBUG temporary
      where(conditions).where(query_conditions).first
    elsif conditions.has_key?(:pseudo) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def connected_with_google_or_github?
    provider == 'google_oauth2' || provider == 'github'
  end

  private

  # Method to remove spaces before and after nickname
  def strip_pseudo
    pseudo.strip! if pseudo.present?
  end

  # Method to check if pseudo is unique after removing spaces before and after nickname
  def unique_stripped_pseudo
    return if pseudo.nil?
    return unless User.where('TRIM(pseudo) = ?', pseudo.strip).where.not(id:).exists?

    # errors.add(:pseudo, 'a déjà été pris')
  end
end
