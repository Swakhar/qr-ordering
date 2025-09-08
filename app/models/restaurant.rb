class Restaurant < ApplicationRecord
  has_many :tables
  has_many :orders
  has_many :menu_categories
end
