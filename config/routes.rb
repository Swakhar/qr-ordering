Rails.application.routes.draw do
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

  get  "/r/:restaurant_slug/t/:table_code", to: "menus#show"
  post "/r/:restaurant_slug/t/:table_code/order", to: "orders#create"

  # Payment
  post "/r/:restaurant_slug/orders/:id/payment_intent", to: "payments#create_intent"
  post "/stripe/webhook", to: "payments#webhook"

  # Kitchen screen
  get "/kitchen/:restaurant_slug", to: "kitchen#index"

  get "/qr/:restaurant_slug/:table_code.png", to: "qr#show"

  root "home#index"
end
