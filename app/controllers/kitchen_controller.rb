class KitchenController < ApplicationController
  before_action :authenticate_staff!, except: [:index] # let viewing without auth if you like

  def index
    @restaurant = Restaurant.find_by!(slug: params[:restaurant_slug])
    @orders = @restaurant.orders.includes(:order_items).order(created_at: :desc).limit(100)
  end

  def update
    order = Order.find(params[:id])
    order.update!(status: params[:status])
    
    # Reload order with associations for rendering
    order = Order.includes(:order_items, :table, :restaurant).find(order.id)
    
    # Render turbo_stream response for the clicker
    render turbo_stream: turbo_stream.replace(
      helpers.dom_id(order),
      partial: "orders/order",
      locals: { order: order }
    )
  end
end
