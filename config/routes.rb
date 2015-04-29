Myflix::Application.routes.draw do
  root to: 'pages#front'

  get '/home/', to: 'videos#index'
  get 'ui(/:action)', controller: 'ui'
  get 'register', to: 'users#new'
  get 'sign_in', to: 'sessions#new'

  resources :videos, only: [:index, :show] do
      collection do
        post :search, to: "videos#search"
      end
  end

  resources :categories, only: [:show]
  resources :users, only: [:create]
end
