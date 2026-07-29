Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "auth/login", to: "auth#login"
      post "auth/register", to: "auth#register"
      get "auth/me", to: "auth#me"
      get "public/rooms", to: "auth#public_rooms"

      get "dashboard/summary", to: "dashboard#summary"
      post "webhooks/vietqr", to: "webhooks#vietqr"
      post "payment_webhooks/sepay", to: "payment_webhooks#sepay"
      post "payment_webhooks/cassso", to: "payment_webhooks#cassso"

      get "export/monthly_bills", to: "export#monthly_bills"
      get "export/operating_expenses", to: "export#operating_expenses"
      get "export/printable_bill/:id", to: "export#printable_bill"

      get "super_admin/overview", to: "super_admin#index"
      post "super_admin/update_plan", to: "super_admin#update_tenant_plan"

      get "trash", to: "trash#index"
      post "trash/restore", to: "trash#restore"

      resource :tenant_settings, only: [:show, :update] do
        post :seed_sample_data, on: :collection
      end

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
        post :send_batch_reminders, on: :collection
      end

      resources :contracts, only: [:index, :create, :destroy] do
        post :checkout, on: :member
        post :renew, on: :member
        match :co_tenants, on: :member, via: [:get, :post]
      end

      resources :monthly_bills, only: [:index, :create, :destroy] do
        post :generate, on: :collection
        post :batch_generate, on: :collection
        get :vietqr, on: :member
        post :mark_as_paid, on: :member
      end
    end
  end
end
