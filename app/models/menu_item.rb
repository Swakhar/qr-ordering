class MenuItem < ApplicationRecord
  belongs_to :menu_category
  has_one :restaurant, through: :menu_category
  has_many :order_items, dependent: :restrict_with_error

  validates :name, presence: true
  validates :price_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }

  scope :active, -> { where(is_active: true) }
  scope :by_category, ->(category_id) { where(menu_category_id: category_id) }

  # Helper methods for price display
  def price_in_currency
    price_cents / 100.0
  end

  def formatted_price(currency = 'EUR')
    "#{currency == 'EUR' ? '€' : currency} #{sprintf('%.2f', price_in_currency)}"
  end
end
