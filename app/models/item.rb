class Item < ApplicationRecord
  has_many :wish_list_items

  RETAILERS = %w[Tesco Asda Morrisons]

  validates :name, uniqueness: true
  validates :generic_name, presence: true
  validates :retailer, inclusion: { in: RETAILERS }
end
