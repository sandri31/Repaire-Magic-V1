# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def about; end

  def services
    !user_signed_in? && redirect_to(root_path, alert: 'Vous devez être connecté pour accéder à cette page')
  end

  def contact; end
end
