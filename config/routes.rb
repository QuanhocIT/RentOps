Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "auth/login", to: "auth#login"
      post "auth/register", to: "auth#register"
      post "auth/google", to: "auth#google_login"
      get "auth/me", to: "auth#me"
      get "public/rooms", to: "auth#public_rooms"

      get "dashboard/summary", to: "dashboard#summary"
      get "ai_advisor/insights", to: "ai_advisor#insights"
      post "webhooks/vietqr", to: "webhooks#vietqr"
      post "payment_webhooks/sepay", to: "payment_webhooks#sepay"
      post "payment_webhooks/cassso", to: "payment_webhooks#cassso"

      get "export/monthly_bills", to: "export#monthly_bills"
      get "export/operating_expenses", to: "export#operating_expenses"
      get "export/printable_bill/:id", to: "export#printable_bill"

      get "super_admin/overview", to: "super_admin#index"
      post "super_admin/create_tenant", to: "super_admin#create_tenant"
      post "super_admin/update_plan", to: "super_admin#update_tenant_plan"
      post "super_admin/toggle_tenant_status", to: "super_admin#toggle_tenant_status"
      delete "super_admin/delete_tenant", to: "super_admin#destroy_tenant"
      post "super_admin/create_plan", to: "super_admin#create_plan"
      put "super_admin/update_plan_details", to: "super_admin#update_plan_details"
      get "super_admin/system_health", to: "super_admin#system_health"
      post "super_admin/broadcast_notification", to: "super_admin#broadcast_notification"
      get "super_admin/audit_logs", to: "super_admin#audit_logs"
      get "super_admin/platform_settings", to: "super_admin#platform_settings"
      post "super_admin/update_platform_settings", to: "super_admin#update_platform_settings"

      get "trash", to: "trash#index"
      post "trash/restore", to: "trash#restore"

      post "automations/trigger_jobs", to: "automations#trigger_jobs"
      post "automations/reconcile_payment", to: "automations#reconcile_payment"

      resource :tenant_settings, only: [:show, :update] do
        post :seed_sample_data, on: :collection
        get :plans, on: :collection
        post :upgrade_plan, on: :collection
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
        match :co_tenants, on: :member, via: [:get, :post, :delete]
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
