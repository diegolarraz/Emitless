class ChangeQuantityInGenericItemsToString < ActiveRecord::Migration[6.0]
  def change
    remove_column :generic_items, :quantity
  end
end
