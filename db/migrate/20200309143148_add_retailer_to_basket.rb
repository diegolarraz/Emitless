class AddRetailerToBasket < ActiveRecord::Migration[6.0]
  def change
    add_column :baskets, :retailer, :string
  end
end
