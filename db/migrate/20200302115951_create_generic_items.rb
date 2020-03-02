class CreateGenericItems < ActiveRecord::Migration[6.0]
  def change
    create_table :generic_items do |t|
      t.string :name
      t.string :image
      t.string :quantity
      t.string :categorysub_category
      t.boolean :in_season

      t.timestamps
    end
  end
end
