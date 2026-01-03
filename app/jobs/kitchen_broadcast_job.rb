class KitchenBroadcastJob < ApplicationJob
  queue_as :default
  def perform(order_id)
    order = Order.includes(:order_items, :restaurant).find(order_id)
    Turbo::StreamsChannel.broadcast_replace_to(
      "kitchen:#{order.restaurant.slug}",
      target: dom_id(order),
      partial: "kitchen/order",
      locals: { order: order }
    )
    Turbo::StreamsChannel.broadcast_prepend_to(
      "kitchen:#{order.restaurant.slug}",
      target: "orders",
      partial: "kitchen/order",
      locals: { order: order }
    )
  end
end
