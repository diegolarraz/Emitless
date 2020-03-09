class Basket < ApplicationRecord
  belongs_to :user
  has_many :basket_items
  has_many :items, through: :basket_items
end
