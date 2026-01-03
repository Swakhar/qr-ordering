class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :menu_item

  validates :qty, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :name_snapshot, presence: true

  def line_total
    price_cents * qty
  end

  def formatted_price(currency = 'EUR')
    "#{currency == 'EUR' ? '€' : currency} #{sprintf('%.2f', price_cents / 100.0)}"
  end
end
