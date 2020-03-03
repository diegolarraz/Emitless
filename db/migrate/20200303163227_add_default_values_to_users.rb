class AddDefaultValuesToUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :total_emissions, :integer, default: 0
  end
end
