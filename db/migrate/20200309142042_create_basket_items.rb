class CreateBasketItems < ActiveRecord::Migration[6.0]
  def change
    create_table :basket_items do |t|
      t.references :item, null: false, foreign_key: true
      t.references :basket, null: false, foreign_key: true
      t.integer :amount

      t.timestamps
    end
  end
end
