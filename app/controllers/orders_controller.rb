class OrdersController < ApplicationController
  include ActionView::RecordIdentifier

  def create
    restaurant = Restaurant.find_by!(slug: params[:restaurant_slug])
    table = restaurant.tables.find_by!(code: params[:table_code])
    lines = JSON.parse(params[:items_json] || "[]") # [{item_id,qty}]
    items = MenuItem.where(id: lines.map { _1["item_id"] }, is_active: true)
    subtotal = lines.sum { |l| items.find { _1.id == l["item_id"] }.price_cents * l["qty"].to_i }
    vat = (subtotal * (restaurant.vat_rate.to_f/100)).round
    total = subtotal + vat

    @order = Order.create!(restaurant:, table:, status: "open",
      subtotal_cents: subtotal, vat_cents: vat, total_cents: total, paid_cents: 0)

    lines.each do |l|
      item = items.find { _1.id == l["item_id"] }
      OrderItem.create!(order: @order, menu_item: item, name_snapshot: item.name,
                        price_cents: item.price_cents, qty: l["qty"].to_i)
    end

    # Broadcast to kitchen immediately
    KitchenBroadcastJob.perform_later(@order.id)

    # redirect to pay page
    redirect_to pay_path(@order.id, r: restaurant.slug)
  end
end
