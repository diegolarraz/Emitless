Rails.application.routes.draw do
  root to: 'pages#home'
  get '/profile', to: 'pages#profile'
  devise_for :users

  require "sidekiq/web"

  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :wish_list_items, only: [:create, :destroy]
  resources :items, only: [:index, :show]
  get 'compare', to: 'wish_list_items#index', as: 'compare'
  get 'basket', to: 'wish_list_items#show', as: 'basket'
end
