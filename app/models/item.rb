class Item < ApplicationRecord
  belongs_to :generic_item
  has_many :order_items

  RETAILERS = %w[Tesco Asda Ocado]

  validates :name, :price, presence: true,
  validates :name, uniqueness: true
  validates :retailer, inclusion: { in: RETAILERS }
end
