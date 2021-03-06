Rails.application.routes.draw do
  get 'confirmations/email'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get '/resetpassword' => 'password_reset#index'
  get '/resetpassword/:token' => 'password_reset#index'

  get 'confirmations', to: 'confirmations#email', as: :confirmation
  get 'home/index'
  get 'home/pubnub'
  root 'home#index'
  resources :users
  post 'process_response', to: 'process_responses#create', as: :process_response

  get '/locations/map'
  get 'reports/registrations', to: 'reports#registrations'

  namespace :admin do
    resources :sessions, only: [:create]
    resources :users
    resources :clients, only: [:index, :show, :create, :update, :destroy] do
      resources :campaigns, only: [:index, :show, :create, :update, :destroy] do
        post :pinit
      end
    end

    root 'home#index'
  end

  namespace :api, defaults: {format: 'json'} do
    get 'yada/:token', to: 'yadas#show', as: 'yada'

    namespace :v1 do
      get 'config', to: 'configs#index'
      get 'search', to: 'searches#index'
      get 'upgrade', to: 'upgrades#index'

      resources :sessions, only: [:create, :destroy, :show]
      resources :users, only: [:index, :create, :update, :show] do
        member do
          get :following, :followers
          patch :recipient
          delete :unfollow
          delete :remove_follower
          patch :password
          put :password
        end
        collection do
          post :follow
          get :registered
        end
        resources :capsules, only: [:index]
        resources :contacts, only: [:index, :create, :destroy]
      end
      resources :capsules do
        collection do
          get :forme
          get :feed
          get :location
        end
        member do
          post   :read
          post   :unlock
        end
        resources :comments, only: [:index, :create, :destroy] do
          member do
            post :like
            delete :unlike
          end
        end
      end
      resources :hashtags, only: [:index]
      resources :location_watches, only: [:create, :destroy]
      resources :password_resets
      resources :block_users, only: [:index, :create, :destroy]

      get 'profile/loadtest/(:id)', to: 'profile#loadtest', as: 'profile_loadtest'
      get 'profile/loadtest_jbuilder/(:id)', to: 'profile#loadtest_jbuilder', as: 'profile_loadtest_jbuilder'
      get 'profile/(:id)', to: 'profile#index', as: 'profile'
      post 'capsules/:capsule_id/objections', to: 'objections#create', as: 'capsule_objections'
      post 'comments/:comment_id/objections', to: 'objections#create', as: 'comment_objections'
    end

    namespace :v1a do
      get 'config', to: 'configs#index'
      get 'search', to: 'searches#index'
      get 'upgrade', to: 'upgrades#index'

      post 'campaigns/redeem', to: 'campaigns#redeem'

      resources :sessions, only: [:create, :destroy, :show]
      resources :users, only: [:index, :create, :update, :show] do
        member do
          get :following, :followers
          patch :recipient
          delete :unfollow
          delete :remove_follower
          patch :password
          put :password
        end
        collection do
          post :follow
          get :registered
        end
        resources :capsules, only: [:index]
        resources :contacts, only: [:index, :create, :destroy]
      end
      resources :capsules do
        collection do
          get :forme
          get :feed
          get :location
          post :forward
        end
        member do
          post :read
          post :unlock
        end
        resources :comments, only: [:index, :create, :destroy] do
          member do
            post :like
            delete :unlike
          end
        end
      end
      resources :hashtags, only: [:index]
      resources :location_watches, only: [:create, :destroy]
      resources :password_resets
      resources :block_users, only: [:index, :create, :destroy]
      resources :categories, only: [:index, :show]

      get 'profile/loadtest/(:id)', to: 'profile#loadtest', as: 'profile_loadtest'
      get 'profile/loadtest_jbuilder/(:id)', to: 'profile#loadtest_jbuilder', as: 'profile_loadtest_jbuilder'
      get 'profile/(:id)', to: 'profile#index', as: 'profile'
      post 'capsules/:capsule_id/objections', to: 'objections#create', as: 'capsule_objections'
      post 'comments/:comment_id/objections', to: 'objections#create', as: 'comment_objections'
    end
  end
end
