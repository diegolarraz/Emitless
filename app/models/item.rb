class Item < ApplicationRecord
  has_many :wish_list_items

  RETAILERS = %w[Tesco Asda Ocado]

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true
  validates :generic_name, presence: true
  validates :retailer, inclusion: { in: RETAILERS }
end
