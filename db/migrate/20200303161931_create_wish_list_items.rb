class CreateWishListItems < ActiveRecord::Migration[6.0]
  def change
    create_table :wish_list_items do |t|
      t.integer :amount
      t.references :user, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
