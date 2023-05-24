# frozen_string_literal: true

class ScryfallService < ApplicationRecord
  include HTTParty

  base_uri 'https://api.scryfall.com'

  def self.search(query)
    get("/cards/search?q=lang:fr+#{CGI.escape(query)}")
  end

  def self.card_price(name)
    get("/cards/named?exact=#{CGI.escape(name)}")
  end

  def self.random
    get('/cards/random')
  end
end
