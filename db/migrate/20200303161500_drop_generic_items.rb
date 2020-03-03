class DropGenericItems < ActiveRecord::Migration[6.0]
  def change
    drop_table :generic_items
  end
end
