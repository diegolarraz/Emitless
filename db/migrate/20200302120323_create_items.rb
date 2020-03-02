class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name
      t.references :generic_item, null: false, foreign_key: true
      t.float :price
      t.float :emission
      t.string :quantity
      t.string :retailer

      t.timestamps
    end
  end
end
