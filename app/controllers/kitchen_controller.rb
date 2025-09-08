class KitchenController < ApplicationController
  def index
    @restaurant = Restaurant.find_by!(slug: params[:restaurant_slug])
    @orders = @restaurant.orders.includes(:order_items).order(created_at: :desc).limit(100)
  end
end
