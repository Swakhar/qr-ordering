class Restaurant < ApplicationRecord
  has_many :tables, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :menu_categories, dependent: :destroy
  has_many :menu_items, through: :menu_categories

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :currency, presence: true, inclusion: { in: %w[EUR USD GBP] }
  validates :vat_rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  before_validation :generate_slug, on: :create

  private

  def generate_slug
    self.slug ||= name&.parameterize
  end
end
