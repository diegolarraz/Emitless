class AddQuantityToGenericItemsAsInteger < ActiveRecord::Migration[6.0]
  def change
    add_column :generic_items, :quantity, :integer
  end
end
