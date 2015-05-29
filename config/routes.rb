Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'home', to: 'videos#index'
  
  resources :users, only: [:create, :show]
  get 'register', to: 'users#new'

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

  resources :relationships, only: [:destroy]
  get 'people', to: 'relationships#index'
  post 'follow', to: 'relationships#create'
  post 'unfollow', to: 'relationships#destroy'
  
  get 'ui(/:action)', controller: 'ui'
end
