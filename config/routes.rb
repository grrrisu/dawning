Dawning::Application.routes.draw do
  root to: "home#index"

  get '/login', to: 'sessions#new', as: :login
  post '/authenticate', to: 'sessions#create', as: :authenticate
  get '/logout', to: 'sessions#destroy', as: :logout
  get '/register', to: 'users#new', as: :register
  get "oauth/callback" => "oauths#callback"
  get "oauth/:provider" => "oauths#oauth", as: :auth_at_provider
  resources :password_resets

  resources :users do
    get :activate, on: :member
  end

  namespace :admin do
    resources :levels, only: [:index, :create, :destroy] do
      member do
        put :build
        put :run
        put :stop
      end
    end
  end
end
