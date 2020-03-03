class Item < ApplicationRecord
  belongs_to :generic_item
  has_many :order_items

  RETAILERS = %w[Tesco Asda Ocado]

  validates :name, presence: true, uniqueness: true
  validates :price, presence:true
  validates :retailer, inclusion: { in: RETAILERS }
end
