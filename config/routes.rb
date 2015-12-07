Dawning::Application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  root to: "home#index"

  get '/login', to: 'sessions#new', as: :login
  post '/authenticate', to: 'sessions#create', as: :authenticate
  get '/logout', to: 'sessions#destroy', as: :logout
  get '/register', to: 'users#new', as: :register
  get "oauth/callback" => "oauths#callback"
  get "oauth/:provider" => "oauths#oauth", as: :auth_at_provider
  resources :password_resets, except: [:index, :destroy]

  resources :users do
    get :activate, on: :member
  end

  resources :levels, only: :index do
    member do
      patch :join
      patch :continue
      delete :leave
    end
    resource :map, only: [:show]
    resource :dungeon, only: [:show]
  end

  namespace :admin do
    resource :launch_panel, only: [:show]
    resource :test_map, only: [:show, :update]
    namespace :api do
      namespace :v1 do
        resources :config_files, defaults: {format: 'json'}, only: [:index]
        resources :levels, defaults: {format: 'json'}, only: [:index, :show, :create, :destroy] do
          member do
            put :join
            put :build
            put :run
            put :stop
            get :objects_count
            post :terminal_command
          end
        end
      end
    end
  end
end
