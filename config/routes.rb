Rails.application.routes.draw do
  devise_for :users
  namespace :admin do
    resources :orders
    resources :products do
      resources :stocks
    end
    resources :categories
  end
  devise_for :admins
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root to: "home#index"

  authenticated :admin_user do
    root to: "admin#index",as: :admin_root
  end

  resources :categories, only: [:show] do
    collection do
      get 'search'
    end
  end
  resources :products,only: [:show]
  get "admin" => "admin#index"
  get "cart" => "carts#show"
  post "checkout" => "checkouts#create"
  get '/success', to: 'checkouts#success', as: 'success'
  get "cancel" => "checkouts#cancel"
  post "webhook" => "webhooks#stripe"
end
