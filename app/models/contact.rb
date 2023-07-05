# frozen_string_literal: true

class Contact < MailForm::Base
  attribute :name,      validate: true
  attribute :email,     validate: ENV['REGEX_EMAIL']
  attribute :phone
  attribute :message, validate: true

  def headers
    {
      to: ENV['MAILER_FROM'],
      subject: "#{name} te contact de ton site: RepaireMagic V1",
      from: %("#{name}" <#{email}>)
    }
  end
end
