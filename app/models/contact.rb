# frozen_string_literal: true

class Contact < MailForm::Base
  attribute :name,      validate: true
  attribute :email,     validate: ENV['REGEX_EMAIL']
  attribute :phone
  attribute :message, validate: true

  def headers
    {
      to: ENV['EMAIL_CONTACT'],
      subject: "#{name} te contact de ton site: Magic",
      from: %("#{name}" <#{email}>)
    }
  end
end
