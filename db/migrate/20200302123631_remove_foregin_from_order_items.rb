class RemoveForeginFromOrderItems < ActiveRecord::Migration[6.0]
  def change
    remove_column :order_items, :basket_id
    add_reference :order_items, :order
  end
end
