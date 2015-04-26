Myflix::Application.routes.draw do
  root to: 'videos#index'

  get '/home/', to: 'videos#index'
  get 'ui(/:action)', controller: 'ui'

  resources :videos, only: [:index, :show] do
      collection do
        post :search, to: "videos#search"
      end
  end

  resources :categories, only: [:show]
end
