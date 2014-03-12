Rails.application.routes.draw do
  get 'home/index'

  root 'home#index'


# API Routes

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :sessions, only: [:create, :destroy, :show]
    end
  end
end
