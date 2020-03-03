class GenericItemsController < ApplicationController
  def category_sorter(array)
    array.select do |item|
      item.category.downcase == params[:category].downcase
    end
  end

  def index
    if params[:query].present?
      @generic_items = GenericItem.where(name: params[:query])
      @generic_items = category_sorter(@generic_items) if params[:category].present?
    else
      @generic_items = GenericItem.all
      @generic_items = category_sorter(@generic_items) if params[:category].present?
    end

  end

  def show
    @generic_item = GenericItem.find(params[:id])
  end
end
