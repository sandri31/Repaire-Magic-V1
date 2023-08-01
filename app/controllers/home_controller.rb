# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :set_devise_resource, only: [:index]

  def index
    @resource ||= User.new

    if params[:payment] == 'cancel'
      redirect_to suscribe_path
      flash[:alert] = 'Le paiement a été annulé.'
    elsif params[:payment] == 'success'
      redirect_to root_path
      flash[:notice] = 'Le paiement a été effectué avec succès.'
    end
  end

  private

  def set_devise_resource
    @resource ||= User.new
    @resource_name ||= :user
    @devise_mapping ||= Devise.mappings[:user]
  end
end
