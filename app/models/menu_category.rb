class MenuCategory < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_items, dependent: :destroy

  validates :name, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  default_scope { order(position: :asc, id: :asc) }
end
