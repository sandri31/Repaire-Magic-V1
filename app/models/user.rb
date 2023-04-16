require 'bcrypt'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true

  attr_accessor :login

  def valid_password?(password)
    bcrypt_password = BCrypt::Password.new(encrypted_password)
    bcrypt_password.is_password?(password)
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    puts "DEBUG: login value is: #{login.inspect}" # DEBUG temporary

    if login
      query_conditions = ['lower(username) = :value OR lower(email) = :value', { value: login.strip.downcase }]
      puts "DEBUG: query_conditions are: #{query_conditions.inspect}" # DEBUG temporary
      where(conditions).where(query_conditions).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end
end
