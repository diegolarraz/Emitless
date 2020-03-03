class AddColumnsToItems < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :generic_name, :string
    add_column :items, :generic_quantity, :integer
    add_column :items, :generic_unit, :string
    add_column :items, :category, :string
    add_column :items, :sub_category, :string
    add_column :items, :seasonal, :boolean, default: false
    remove_foreign_key :items, column: :generic_item_id
  end
end
