# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             controllers: { sessions: 'sessions', registrations: 'registrations', passwords: 'users/passwords',
                            unlocks: 'unlocks', confirmations: 'users/confirmations',
                            omniauth_callbacks: 'users/omniauth_callbacks' }, skip: [:sessions]
  as :user do
    get 'users/sign_in' => 'sessions#new', as: :new_user_session
    post 'users/sign_in' => 'sessions#create', as: :user_session
    delete 'users/sign_out' => 'sessions#destroy', as: :destroy_user_session
  end

  resources :cards do
    collection do
      get 'top'
    end
  end

  # Home page
  root 'home#index'

  # Contact page
  get 'contact', to: 'static_pages#contact', as: 'contact'
  post 'contact', to: 'static_pages#create', as: :contact_submit

  # Static pages
  get 'about', to: 'static_pages#about'
  get 'services', to: 'static_pages#services'
  get 'suscribe', to: 'static_pages#suscribe'

  # Stripe
  resources :subscriptions do
    collection do
      post :create_checkout_session
    end
  end
  post 'stripe_webhooks', to: 'stripe_webhooks#create'

  # Random page
  get 'random', to: 'random#random'
end
