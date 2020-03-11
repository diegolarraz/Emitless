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
    # raise
    self.baskets.last.basket_item_ids.each do |id|
      if best_swap
        if BasketItem.find(id).item_id == self.id
          basket_item = BasketItem.find(id)
          # raise
          if best_swap.emission * best_swap.calculate_swap(basket_item) > basket_item.amount * self.emission || Item.find(BasketItem.find(id).item_id).id == best_swap.id
            # raise
          # raise
            best_swap = nil
          end
        # elsif Item.find(BasketItem.find(id).item_id).id == best_swap.id
        #   best_swap = nil
        end
      end
    end
    return best_swap
  end

  def calculate_swap(basket_item)
    desired_quantity = basket_item.item.quantity.to_f * basket_item.amount.to_i
    if self.unit == basket_item.item.unit
      required_amount = desired_quantity / self.quantity.to_i
    elsif self.unit == "g" && basket_item.item.unit == "kg"
      required_amount = desired_quantity * 1000 / self.quantity.to_i
    elsif self.unit == "kg" && basket_item.item.unit == "g"
      required_amount = desired_quantity / 1000 / self.quantity.to_i
    elsif self.unit == "each" && basket_item.item.unit != "each"
      if self.category == "fruit"
        required_amount = desired_quantity / 100
      elsif self.category == "vegetable"
        required_amount = desired_quantity / 250
      elsif self.category == ("meat" || "seafood")
        required_amount = desired_quantity / 150
      end
    elsif self.unit != "each" && basket_item.item.unit == "each"
      if self.category == "fruit"
        desired_quantity = desired_quantity * 100
        required_amount = desired_quantity / self.quantity.to_i
      elsif self.category == "vegetable"
        desired_quantity = desired_quantity * 250
        required_amount = desired_quantity / self.quantity.to_i
      elsif self.category == ("meat" || "seafood")
        desired_quantity = desired_quantity * 150
        required_amount = desired_quantity / self.quantity.to_i
      end
    end
    if required_amount < 1
      required_amount = 1
    end
  return required_amount.round()
  end

end
