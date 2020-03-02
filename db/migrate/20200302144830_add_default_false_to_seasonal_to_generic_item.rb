class AddDefaultFalseToSeasonalToGenericItem < ActiveRecord::Migration[6.0]
  def change
    change_column :generic_items, :in_season, :boolean, default: false
  end
end
