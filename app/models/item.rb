class Item < ApplicationRecord
  has_many :wish_list_items, dependent: :destroy

  RETAILERS = %w[Tesco Ocado Morrisons]

  validates :name, uniqueness: true
  validates :price, presence: true
  validates :quantity, presence: true
  validates :generic_name, presence: true
  validates :retailer, inclusion: { in: RETAILERS }
end
