# frozen_string_literal: true

class Card < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :user_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :printed_name, presence: true, uniqueness: { scope: :user_id }
  delegate :total_price, to: :cards, prefix: true

  scope :white, -> { where(color_identity: 'W') }
  scope :blue, -> { where(color_identity: 'U') }
  scope :black, -> { where(color_identity: 'B') }
  scope :red, -> { where(color_identity: 'R') }
  scope :green, -> { where(color_identity: 'G') }
  scope :colorless, -> { where(color_identity: '') }
  scope :multicolor, lambda {
                       where.not(color_identity: 'W').where.not(color_identity: 'U').where.not(color_identity: 'B')
                            .where.not(color_identity: 'R').where.not(color_identity: 'G').where.not(color_identity: '')
                     }

  def self.sorted_by_color(user_id)
    {
      white: Card.white.where(user_id:),
      blue: Card.blue.where(user_id:),
      black: Card.black.where(user_id:),
      red: Card.red.where(user_id:),
      green: Card.green.where(user_id:),
      colorless: Card.colorless.where(user_id:),
      multicolor: Card.multicolor.where(user_id:)
    }
  end

  def total_price
    price * quantity
  end

  # If the quantity is 0, we destroy the card
  def destroy_if_quantity_is_zero
    return unless quantity <= 0

    destroy
  end

  def self.exists_by_name_and_user?(name, user_id)
    Card.exists?(name:, user_id:)
  end
end
