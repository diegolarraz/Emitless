Rails.application.routes.draw do
  root to: 'pages#home'
  get '/profile', to: 'pages#profile'
  devise_for :users

  resources :items, only: [:index, :show]
  resources :wish_list_items, only: [:index, :show, :create]
end
