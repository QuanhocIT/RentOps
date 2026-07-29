Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "auth/login", to: "auth#login"
      get "auth/me", to: "auth#me"

      resources :properties, only: [:index, :create]
      resources :rooms
      resources :contracts, only: [:index, :create] do
        post :checkout, on: :member
      end
      resources :monthly_bills, only: [:index, :create] do
        post :generate, on: :collection
      end
    end
  end
end
