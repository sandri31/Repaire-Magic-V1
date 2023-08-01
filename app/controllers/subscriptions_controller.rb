# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, only: [:create_checkout_session]

  def new; end

  def create_checkout_session
    Stripe.api_key = Rails.env.production? ? ENV['STRIPE_SECRET_KEY'] : ENV['STRIPE_TEST_SECRET_KEY']

    plan_id = params[:plan]

    session = Stripe::Checkout::Session.create({
                                                 payment_method_types: ['card'],
                                                 line_items: [{
                                                   price: plan_id,
                                                   quantity: 1
                                                 }],
                                                 mode: 'subscription',
                                                 success_url: root_url + '?payment=success',
                                                 cancel_url: root_url + '?payment=cancel'
                                               })

    redirect_to session.url, status: 303, allow_other_host: true
  end

  private

  def authenticate_user!
    return if user_signed_in?

    redirect_to suscribe_path, alert: 'Vous devez vous connecter pour souscrire à un abonnement.'
  end
end
