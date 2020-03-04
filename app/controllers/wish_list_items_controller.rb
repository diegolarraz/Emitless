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
    @wish_list_items = WishListItem.all
    all_item_instances = {}

    @wish_list_items.each do |wish_item|
      all_item_instances[wish_item] = Item.where(generic_name: wish_item.item.generic_name)
    end

    @items = {
      tesco_items: [],
      morrisons_items: [],
      ocado_items: []
    }

    all_item_instances.each do |item_arrays|
      item_arrays.each do |item_instance|
        case item_instance.retailer
        when "Tesco"
          @items[tesco_items] << item_instance
        when "Morrisons"
          @items[morrisons_items] << item_instance
        when "Ocado"
          @items[ocado_items] << item_instance
        end
      end
    end
    raise
  end

  private

  def wish_list_item_params
    params.require(:wish_list_item).permit(:amount)
  end
end
