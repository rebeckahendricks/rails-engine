Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/find', controller: 'merchants/search', action: :show
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: 'merchants/items'
      end
      resources :items do
        resource :merchant, only: [:show], controller: 'items/merchant'
      end
    end
  end
end
