Rails.application.routes.draw do
  devise_for :users,
             controllers: { sessions: 'sessions', registrations: 'registrations', passwords: 'users/passwords',
                            confirmations: 'users/confirmations' }

  get 'about', to: 'static_pages#about'
  get 'services', to: 'static_pages#services'
  get 'contact', to: 'static_pages#contact'

  root 'home#index'
end
