class Payment < ApplicationRecord
  belongs_to :order

  validates :stripe_payment_intent, presence: true, uniqueness: true
  validates :amount_cents, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :status, presence: true

  scope :successful, -> { where(status: 'succeeded') }
  scope :pending, -> { where(status: %w[processing requires_payment_method requires_confirmation]) }

  def formatted_amount(currency = 'EUR')
    "#{currency == 'EUR' ? '€' : currency} #{sprintf('%.2f', amount_cents / 100.0)}"
  end
end
