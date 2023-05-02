# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :set_devise_resource, only: [:index]

  def index
    @resource ||= User.new
  end

  private

  def set_devise_resource
    @resource ||= User.new
    @resource_name ||= :user
    @devise_mapping ||= Devise.mappings[:user]
  end
end
