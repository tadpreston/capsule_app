Rails.application.routes.draw do
  get 'confirmations/email'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get 'confirmations', to: 'confirmations#email', as: :confirmation
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
          patch :recipient
        end
        resources :capsules, only: [:index]
        resources :contacts, only: [:index, :create, :destroy]
      end
      resources :capsules do
        collection do
          get 'explorer'
          get 'locationtags'
          get 'watched'
          get 'forme'
          get 'suggested'
          get 'library'
          get 'loadtest'
        end
        member do
          get 'replies'
          get 'replied_to'
          post 'read'
          delete 'unread'
          post 'watch'
          delete 'unwatch'
          post 'like'
          delete 'unlike'
        end
        resources :comments, only: [:create, :destroy]
      end
      resources :relationships, only: [:create, :destroy]
      resources :hashtags, only: [:index]
      resources :location_watches, only: [:create, :destroy]
    end
  end
end
