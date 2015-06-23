Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'home', to: 'videos#index'

  resources :users, only: [:create, :show]
  get 'register', to: 'users#new'
  get 'register/:token', to: 'users#new_with_invitation_token',
    as: 'register_with_token'

  namespace :admin do
    resources :videos, only: [:new, :create]
  end

  resources :sessions, only: [:create, :destroy]
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'

  resources :videos, only: [:index, :show] do
    collection do
      post :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end

  resources :categories, only: [:show]

  resources :queue_items, only: [:create, :destroy]
  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'

  resources :relationships, only: [:create, :destroy]
  get 'people', to: 'relationships#index'

  resources :forgot_passwords, only: [:create]
  get 'forgot_password', to: 'forgot_passwords#new'
  get 'forgot_password_confirmation', to: 'forgot_passwords#confirm'

  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'pages#expired_token'

  resources :invitations, only: [:new, :create]

  resources :payments, only: [:new, :create]

  get 'ui(/:action)', controller: 'ui'
  
  # Sidekiq monitoring
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
