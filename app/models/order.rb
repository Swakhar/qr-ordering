class Order < ApplicationRecord
  belongs_to :restaurant
  belongs_to :table
  has_many :order_items, dependent: :destroy
  has_many :menu_items, through: :order_items
  has_many :payments, dependent: :destroy

  validates :status, presence: true, inclusion: { in: %w[open preparing ready served paid cancelled] }
  validates :subtotal_cents, :vat_cents, :total_cents, :paid_cents, 
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

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
end
