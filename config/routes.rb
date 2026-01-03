Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :staffs
  namespace :admin do
    resources :ingest, only: [:new, :create]
  end

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

  get "/qr/:restaurant_slug/:table_code.png", to: "qr#show"
  patch "/orders/:id/status", to: "kitchen#update", as: :order_status

  root "home#index"
end
