class ChangeTableNames < ActiveRecord::Migration[6.0]
  def change
    rename_table :baskets, :orders
    rename_table :basket_items, :order_items
  end
end
