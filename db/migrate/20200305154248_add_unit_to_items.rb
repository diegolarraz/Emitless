class AddUnitToItems < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :unit, :string
  end
end
