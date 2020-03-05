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
    if WishListItem.where(user: current_user).blank?
      flash[:notice] = "Your basket seems to be empty!"
      redirect_to items_path
    end
    @wish_list_items = WishListItem.includes(:item).where(user: current_user)
    @basket = {
              tesco: {},
              ocado: {},
              morrisons: {}
              }

    Item::RETAILERS.each do |retailer|
      @basket[retailer.downcase.to_sym][:emissions] = 0.0
      @basket[retailer.downcase.to_sym][:price] = 0.0
      @basket[retailer.downcase.to_sym][:items] = {}

      @wish_list_items.each do |wish_list_item|
        @basket[retailer.downcase.to_sym][:items][wish_list_item.item.generic_name] = {}
        # Finding the best item with the lowest emissions
        best_item = Item.order(emission: :asc).where("generic_name = ? AND retailer = ?", wish_list_item.item.generic_name.to_s, retailer.to_s).first
        # Quantity of item
        @basket[retailer.downcase.to_sym][:items][wish_list_item.item.generic_name][:item] = best_item
        @basket[retailer.downcase.to_sym][:items][wish_list_item.item.generic_name][:amount] = 1


        while @basket[retailer.downcase.to_sym][:items][wish_list_item.item.generic_name][:amount] * best_item.quantity.to_i < wish_list_item.amount * best_item.generic_quantity
          @basket[retailer.downcase.to_sym][:items][wish_list_item.item.generic_name][:amount] += 1
        end

        # Total price and emissions
        @basket[retailer.downcase.to_sym][:price] += (best_item.price * @basket[retailer.downcase.to_sym][:items][wish_list_item.item.generic_name][:amount]) unless best_item.nil?
        @basket[retailer.downcase.to_sym][:emissions] += (best_item.emission * @basket[retailer.downcase.to_sym][:items][wish_list_item.item.generic_name][:amount]) unless best_item.nil?
      end
    end

    @basket = @basket.sort_by { |retailer, infos| infos[:emissions] }

    return @basket
  end

  def destroy
    @wish_list_item = WishListItem.find(params[:id])
    @wish_list_item.destroy
    redirect_to items_path
  end

  def plus_amount
    @wish_list_item = WishListItem.find(params[:id])
    @wish_list_item.amount += 1
    @wish_list_item.save
    redirect_to items_path
  end

  def minus_amount
    @wish_list_item = WishListItem.find(params[:id])
    @wish_list_item.amount -= 1
    @wish_list_item.save
    if @wish_list_item.amount < 1
      @wish_list_item.destroy
    end
    redirect_to items_path
  end
    
  def show
    @retailer = params[:retailer]
    @items = params[:basket][:items]
    @emissions = params[:basket][:emissions].to_i
    @price = params[:basket][:price].to_i
  end

  private

  def wish_list_item_params
    params.require(:wish_list_item).permit(:amount)
  end
end
