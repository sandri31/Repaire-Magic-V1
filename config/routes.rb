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

  get 'about', to: 'static_pages#about'
  get 'services', to: 'static_pages#services'
  get 'contact', to: 'static_pages#contact'

  root 'home#index'
end
