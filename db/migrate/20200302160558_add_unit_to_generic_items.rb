class AddUnitToGenericItems < ActiveRecord::Migration[6.0]
  def change
    add_column :generic_items, :unit, :string
  end
end
