Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get 'home/index'
  root 'home#index'
  resources :users

# API Routes

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      get 'config', to: 'configs#index'

      resources :sessions, only: [:create, :destroy, :show]
      resources :users, only: [:index, :create, :update, :show] do
        member do
          get :following, :followers
        end
        collection do
          get :contacts
        end
        resources :capsules, only: [:index]
      end
      resources :capsules do
        collection do
          get 'explorer'
          get 'locationtags'
          get 'watched'
        end
        resource :comments, only: [:create, :destroy]
      end
      resources :relationships, only: [:create, :destroy]
    end
  end
end
