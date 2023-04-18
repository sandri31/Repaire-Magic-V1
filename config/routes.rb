Rails.application.routes.draw do
  devise_for :users,
             controllers: { sessions: 'sessions', registrations: 'registrations', passwords: 'users/passwords',
                            confirmations: 'users/confirmations' }
  root 'home#index'
end
