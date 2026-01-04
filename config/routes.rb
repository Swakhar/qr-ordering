Rails.application.routes.draw do
  devise_for :staffs
  
  # Custom admin routes
  namespace :admin do
    resources :ingest, only: [:new, :create]
    resources :qr_codes, only: [:index, :show] do
      member do
        get 'download'
      end
      collection do
        get 'download_all'
      end
    end
    get 'dashboard', to: 'dashboard#index', as: 'dashboard'
    root to: 'dashboard#index'
  end
  
  # Rails Admin at different path
  mount RailsAdmin::Engine => '/rails_admin', as: 'rails_admin'

  get "kitchen/index"
  get "payments/create_intent"
  get "payments/webhook"
  get "orders/create"
  get "menus/show"
  get "home/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get  "/r/:restaurant_slug/t/:table_code", to: "menus#show", as: :menu
  post "/r/:restaurant_slug/t/:table_code/order", to: "orders#create", as: :create_order
  post "/r/:restaurant_slug/upsell", to: "menus#upsell", as: :upsell

  # Payment
  post "/r/:restaurant_slug/orders/:id/payment_intent", to: "payments#create_intent", as: :create_payment_intent
  post "/stripe/webhook", to: "payments#webhook"
  get "/pay/:id", to: "payments#show", as: :pay

  # Kitchen screen
  get "/kitchen/:restaurant_slug", to: "kitchen#index", as: :kitchen
  get "/kitchen/:restaurant_slug", to: "kitchen#index"

  get "/qr/:restaurant_slug/:table_code.png", to: "qr#show", as: :qr
  patch "/orders/:id/status", to: "kitchen#update", as: :order_status

  root "home#index"
end
