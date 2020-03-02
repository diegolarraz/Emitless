Rails.application.routes.draw do
  root to: 'pages#home'
  get '/profile', to: 'pages#profile'
  get '/profile/:exchange', to: 'pages#confirm?', as: 'confirm'
  devise_for :users

  resources :generic_items, only: [:show, :index]
  resources :items, only: [:show, :index]
  resources :orders, only: [:edit, :update, :create, :new, :show]

end
