class KitchenBroadcastJob < ApplicationJob
  include ActionView::RecordIdentifier
  
  queue_as :default
  
  def perform(order_id)
    order = Order.includes(:order_items, :table, :restaurant).find(order_id)
    
    # Check if this is a new order (just created)
    is_new_order = order.created_at > 10.seconds.ago
    
    if is_new_order
      # Prepend new order to the top of the list
      Turbo::StreamsChannel.broadcast_prepend_to(
        "kitchen:#{order.restaurant.slug}",
        target: "orders",
        partial: "orders/order",
        locals: { order: order }
      )
    else
      # Update existing order
      Turbo::StreamsChannel.broadcast_replace_to(
        "kitchen:#{order.restaurant.slug}",
        target: dom_id(order),
        partial: "orders/order",
        locals: { order: order }
      )
    end
  end
end
