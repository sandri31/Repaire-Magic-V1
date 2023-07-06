# frozen_string_literal: true

class RandomController < ApplicationController
  def random
    begin
      @card = ScryfallService.random
      @magic_symbols = magic_symbols
    rescue NoMethodError => e
      flash[:error] = "Une erreur est survenue lors de la génération d'une carte aléatoire. Veuillez réessayer."
      redirect_to root_path
    end
  end

  private

  def magic_symbols
    base_url = 'https://www.smfcorp.net/images/grosmanas/%%7B%s%%7D.png'
    symbols = %w[R W U B G C X Y Z T] + (0..20).map(&:to_s)
    symbols.map { |symbol| [format('{%s}', symbol), format(base_url, symbol)] }.to_h
  end
end
