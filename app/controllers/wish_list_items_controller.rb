class WishListItemsController < ApplicationController
  def create
    @item = Item.find(params[:wish_list_item][:item].to_i)
    @wish_list_item = WishListItem.create(wish_list_item_params)
    @wish_list_item.item = @item
    @wish_list_item.user = current_user
    if !@wish_list_item.save
      flash[:notice] = "Oh no, something went wrong!"
    end
    redirect_to items_path
  end

  def index
    @wish_list_items = WishListItem.where(user: current_user)

    @basket = {
              tesco: {},
              ocado: {},
              morrisons: {}
              }

    Item::RETAILERS.each do |retailer|
      @basket[retailer.downcase.to_sym][:items] = []
      @basket[retailer.downcase.to_sym][:emissions] = 0.0
      @basket[retailer.downcase.to_sym][:price] = 0.0

      @wish_list_items.each do |wish_list_item|
        best_item = Item.order(emission: :asc).where("generic_name = ? AND retailer = ?", wish_list_item.item.generic_name.to_s, retailer.to_s).first
        @basket[retailer.downcase.to_sym][:items] << best_item
        @basket[retailer.downcase.to_sym][:price] += best_item.price unless best_item.nil?
        @basket[retailer.downcase.to_sym][:emissions] += best_item.emission unless best_item.nil?
      end
    end

    return @basket
  end

  def destroy
    @wish_list_item = WishListItem.find(params[:id])
    @wish_list_item.destroy
    redirect_to items_path
  end

  private

  def wish_list_item_params
    params.require(:wish_list_item).permit(:amount)
  end
end
