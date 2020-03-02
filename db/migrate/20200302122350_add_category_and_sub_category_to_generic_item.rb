class AddCategoryAndSubCategoryToGenericItem < ActiveRecord::Migration[6.0]
  def change
    add_column :generic_items, :category, :string
    add_column :generic_items, :sub_category, :string
  end
end
