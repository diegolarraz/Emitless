class Basket < ApplicationRecord
  belongs_to :user
  has_many :basket_items
  has_many :items, through: :basket_items

  def calculate_emissions
    basket.emissions = 0
    basket.items.each do |item|
      basket.emissions += item.emission
    end
    return basket.emissions
    raise
  end
end
