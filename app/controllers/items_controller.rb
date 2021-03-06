class ItemsController < ApplicationController

  def index
    @wish_list_item = WishListItem.new()
    if params[:query].present?
      @items = Item.where("generic_name ILIKE ?", "%#{params[:query]}%").uniq(&:generic_name)
      @items = category_sorter(@items) if params[:category].present?
    else
      @items = Item.all.uniq(&:generic_name)
      @items = category_sorter(@items) if params[:category].present?
    end
    @wishes = current_user.wish_list_items.order(created_at: :asc)
  end

  def show
    @item = Item.find(params[:id])
  end

  private

  def category_sorter(array)
    array.select do |item|
      item.category.downcase == params[:category].downcase
    end
  end
end


