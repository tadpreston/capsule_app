Rails.application.routes.draw do
  get 'home/index'

  root 'home#index'


  resources :users

# API Routes

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      get 'config', to: 'configs#index'

      resources :sessions, only: [:create, :destroy, :show]
      resources :users, only: [:index, :create, :update, :show]
      resources :capsules do
        collection do
          get 'watched'
        end
      end
    end
  end
end
