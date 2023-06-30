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

  # Static pages
  get 'about', to: 'static_pages#about'
  get 'services', to: 'static_pages#services'
  get 'contact', to: 'static_pages#contact', as: 'contact'
  post 'contact', to: 'static_pages#create', as: :contact_submit

  # Random page
  get 'random', to: 'random#random'
end
