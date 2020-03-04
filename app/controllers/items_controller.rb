class ItemsController < ApplicationController

  def category_sorter(array)
    array.select do |item|
      item.category.downcase == params[:category].downcase
    end
  end

  def index
    if params[:query].present?
      @items = Item.where(name: params[:query], retailer: "Tesco")
      @items = category_sorter(@items) if params[:category].present?
    else
      @items = Item.where(retailer: "Tesco")
      @items = category_sorter(@items) if params[:category].present?
    end

  end

  def show
    @item = Item.find(params[:id])
  end
end
