class WishListItemsController < ApplicationController
  def create
    @item = Item.find(params[:wish_list_item][:item].to_i)
    @wish_list_item = WishListItem.create(wish_list_item_params)
    @wish_list_item.item = @item
    @wish_list_item.user = current_user
    if !@wish_list_item.save
      flash[:notice] = "Oh no something went wrong"
    end
    redirect_to items_path
  end

  def index
    @wish_list_items = WishListItem.all
  end

  private

  def wish_list_item_params
    params.require(:wish_list_item).permit(:amount)
  end
end
