class Table < ApplicationRecord
  belongs_to :restaurant
  has_many :orders, dependent: :destroy

  validates :code, presence: true, uniqueness: { scope: :restaurant_id }
  validates :label, presence: true

  before_validation :generate_code, on: :create

  private

  def generate_code
    self.code ||= SecureRandom.alphanumeric(8).upcase
  end
end
