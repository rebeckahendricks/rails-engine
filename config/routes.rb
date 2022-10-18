Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index]
      resources :items, only: [:index]
    end
  end
end
