class AddColumnsToDifferentTables < ActiveRecord::Migration[6.0]
  def change
    remove_reference :items, :generic_item
    add_column :users, :total_emissions, :integer
  end
end
