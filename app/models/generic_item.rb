class GenericItem < ApplicationRecord
  has_many :items

  validates :name, :category, :sub_category, presence: true
  validates :name, uniqueness: { scope: :retailer }
end
