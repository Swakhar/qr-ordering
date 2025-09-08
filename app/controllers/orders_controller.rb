class OrdersController < ApplicationController
  def create
    restaurant = Restaurant.find_by!(slug: params[:restaurant_slug])
    table = restaurant.tables.find_by!(code: params[:table_code])

    lines = params.require(:items) # [{item_id, qty, notes}]
    items = MenuItem.where(id: lines.map { _1[:item_id] }).where(is_active: true)
    subtotal = lines.sum { |l| items.find { _1.id == l[:item_id] }.price_cents * l[:qty].to_i }
    vat = (subtotal * (restaurant.vat_rate.to_f / 100.0)).round
    total = subtotal + vat

    order = Order.create!(restaurant:, table:, status: "open",
                          subtotal_cents: subtotal, vat_cents: vat, total_cents: total, paid_cents: 0)

    lines.each do |l|
      item = items.find { _1.id == l[:item_id] }
      OrderItem.create!(order:, menu_item: item, name_snapshot: item.name,
                        price_cents: item.price_cents, qty: l[:qty].to_i, notes: l[:notes])
    end

    render json: { id: order.id, total_cents: order.total_cents, status: order.status }
  end
end
