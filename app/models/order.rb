class Order < ApplicationRecord
  belongs_to :restaurant
  belongs_to :table
  has_many :order_items, dependent: :destroy
  has_many :menu_items, through: :order_items
  has_many :payments, dependent: :destroy

  validates :status, presence: true, inclusion: { in: %w[open preparing ready served paid cancelled] }
  validates :subtotal_cents, :vat_cents, :total_cents, :paid_cents, 
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # Broadcast updates to kitchen display in real-time (only for updates, not creates)
  # Creates are handled by KitchenBroadcastJob after order_items are added
  after_commit :broadcast_to_kitchen, on: :update

  scope :open, -> { where(status: 'open') }
  scope :active, -> { where(status: %w[open preparing ready served]) }
  scope :recent, -> { order(created_at: :desc) }

  def remaining_balance
    total_cents - paid_cents
  end

  def fully_paid?
    paid_cents >= total_cents
  end

  def formatted_total(currency = 'EUR')
    "#{currency == 'EUR' ? '€' : currency} #{sprintf('%.2f', total_cents / 100.0)}"
  end

  private

  def broadcast_to_kitchen
    Rails.logger.info "🔔 Broadcasting order ##{id} to kitchen:#{restaurant.slug}"
    # Eager load associations for broadcasting
    order_with_associations = Order.includes(:order_items, :table, :restaurant).find(id)
    broadcast_replace_to(
      "kitchen:#{restaurant.slug}",
      target: order_with_associations,
      partial: "orders/order",
      locals: { order: order_with_associations }
    )
    Rails.logger.info "✅ Broadcast completed for order ##{id}"
  rescue => e
    Rails.logger.error "❌ Broadcast failed for order ##{id}: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
  end
end
