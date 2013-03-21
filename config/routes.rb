Dawning::Application.routes.draw do
  root to: "home#index"

  get '/login', to: 'sessions#new', as: :login
  post '/authenticate', to: 'sessions#create', as: :authenticate
  get '/logout', to: 'sessions#destroy', as: :logout
  get '/register', to: 'users#new', as: :register
  match "oauth/callback" => "oauths#callback"
  match "oauth/:provider" => "oauths#oauth", as: :auth_at_provider
  resources :password_resets

  resources :users do
    get :activate, on: :member
  end
end
