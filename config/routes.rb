Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "auth/login", to: "auth#login"
      post "auth/register", to: "auth#register"
      get "auth/me", to: "auth#me"
      get "public/rooms", to: "auth#public_rooms"

      get "dashboard/summary", to: "dashboard#summary"
      post "webhooks/vietqr", to: "webhooks#vietqr"

      get "super_admin/overview", to: "super_admin#index"
      post "super_admin/update_plan", to: "super_admin#update_tenant_plan"

      get "trash", to: "trash#index"
      post "trash/restore", to: "trash#restore"

      resource :tenant_settings, only: [:show, :update]

      resources :properties, only: [:index, :create, :destroy]
      resources :rooms, only: [:index, :create, :update, :destroy]
      resources :renters, only: [:index, :create, :update, :destroy]
      resources :services, only: [:index, :create, :update, :destroy]
      resources :utility_readings, only: [:index, :create, :destroy] do
        post :batch_create, on: :collection
      end
      resources :operating_expenses, only: [:index, :create, :destroy]
      resources :audit_logs, only: [:index]
      resources :maintenance_requests, only: [:index, :create, :update, :destroy]
      resources :amenities, only: [:index, :create, :destroy]
      resources :room_assets, only: [:index, :create, :update, :destroy]
      resources :contract_templates, only: [:index, :create, :update]

      resources :payment_transactions, only: [:index] do
        post :webhook, on: :collection
      end

      resources :notifications, only: [:index] do
        post :send_reminder, on: :collection
      end

      resources :contracts, only: [:index, :create, :destroy] do
        post :checkout, on: :member
        post :renew, on: :member
      end

      resources :monthly_bills, only: [:index, :create, :destroy] do
        post :generate, on: :collection
        get :vietqr, on: :member
      end
    end
  end
end

