class Basket < ApplicationRecord
  belongs_to :user
  has_many :basket_items
  has_many :items, through: :basket_items

  # def calculate_emissions(basket)
  #   basket.emissions = 0
  #   basket.items.each do |item|
  #     basket.emissions += item.emission
  #   end
  #   return basket.emissions
  # end
end
