class ItemsController < ApplicationController
  respond_to :html, :js

  def category_sorter(array)
    array.select do |item|
      item.category.downcase == params[:category].downcase
    end
  end

  def index
    if params[:query].present?
      @items = Item.where("generic_name ILIKE ?", "%#{params[:query]}%").uniq(&:generic_name)
      @items = category_sorter(@items) if params[:category].present?
    else
      @items = Item.all.uniq(&:generic_name)
      @items = category_sorter(@items) if params[:category].present?
    end
  end

  respond_to do |format|
    format.html
    format.js
  end

  def show
    @item = Item.find(params[:id])
  end
end


