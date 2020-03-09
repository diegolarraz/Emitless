class AddDefaultValuesToBasketTables < ActiveRecord::Migration[6.0]
  def change
    change_column :basket_items, :amount, :integer, default: 0
    change_column :baskets, :emissions, :float, default: 0
    change_column :baskets, :price, :float, default: 0
  end
end
