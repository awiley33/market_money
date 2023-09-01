Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :markets, only: [:index, :show] do
        resources :vendors, only: [:index], to: 'market_vendors#index'
      end
      resources :market_vendors, only: [:create]
      resources :vendors, only: [:show, :create, :update, :destroy]
    end
  end
end
