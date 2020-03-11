class Item < ApplicationRecord
  has_many :wish_list_items, dependent: :destroy
  has_many :basket_items, dependent: :destroy
  has_many :baskets, through: :basket_items

  RETAILERS = %w[Tesco Ocado Morrisons]

  validates :name, uniqueness: true, presence: true
  validates :price, presence: true
  validates :quantity, presence: true
  validates :generic_name, presence: true
  validates :retailer, inclusion: { in: RETAILERS }
  validates :price, presence: true

  def find_swap
    best_swap = Item.order(emission: :asc).where.not("id = ?", self.id).where("retailer = ? AND sub_category = ? AND emission < ?", self.retailer, self.sub_category, self.emission).first
    self.baskets.last.basket_item_ids.each do |id|
      if best_swap
        if Item.find(BasketItem.find(id).item_id).id == best_swap.id
          best_swap = nil
        end
      end
    end
    return best_swap
  end

end
