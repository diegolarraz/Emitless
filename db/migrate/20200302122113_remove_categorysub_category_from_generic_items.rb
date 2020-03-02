class RemoveCategorysubCategoryFromGenericItems < ActiveRecord::Migration[6.0]
  def change
    remove_column :generic_items, :categorysub_category
  end
end
