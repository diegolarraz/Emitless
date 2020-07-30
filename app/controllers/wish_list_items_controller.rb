class WishListItemsController < ApplicationController
  respond_to :html, :js

  respond_to do |format|
    format.html
    format.js
  end

  def create
    @wish_list_item = WishListItem.new(wish_list_item_params)
    @wish_list_item.user = current_user
    if @wish_list_item.save
      render :create
    else
      flash[:notice] = "Oh no, something went wrong!"
    end
  end

  def index
    if WishListItem.where(user: current_user).blank?
      flash[:notice] = "Your basket seems to be empty!"
      redirect_to items_path
    end
    @wish_list_items = WishListItem.includes(:item).where(user: current_user)

    # Item::RETAILERS.each do |retailer|
    #   retailer = Basket.new(retailer: retailer)

    #   @wish_list_items.each do |wish_list_item|
    #     # Finding the best item with the lowest emissions

    #   end

    # end

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
        # Finding the best item with the lowest emissions
        best_item = Item.order(emission: :asc).where("generic_name = ? AND retailer = ?", wish_list_item.item.generic_name.to_s, retailer.to_s).first
        if best_item
          # Quantity of item
          # @basket[retailer.downcase.to_sym][:items][best_item] = best_item
          @basket[retailer.downcase.to_sym][:items][wish_list_item.item.generic_name] = [1, best_item]
          if best_item.unit == "kg" && best_item.generic_unit == "g"
            best_item.quantity = best_item.quantity * 1000
          end
          while @basket[retailer.downcase.to_sym][:items][wish_list_item.item.generic_name][0] * best_item.quantity.to_i < wish_list_item.amount * best_item.generic_quantity
            # raise
            @basket[retailer.downcase.to_sym][:items][wish_list_item.item.generic_name][0] += 1
          end

          # Total price and emissions
          @basket[retailer.downcase.to_sym][:price] += (best_item.price * @basket[retailer.downcase.to_sym][:items][wish_list_item.item.generic_name][0]) unless best_item.nil?
          @basket[retailer.downcase.to_sym][:emissions] += (best_item.emission * @basket[retailer.downcase.to_sym][:items][wish_list_item.item.generic_name][0]) unless best_item.nil?
        end
      end
    end

    @basket[:ocado][:emissions] = @basket[:tesco][:emissions] + 12
    @basket[:morrisons][:emissions] = @basket[:tesco][:emissions] + 6
    # raise

    @basket = @basket.sort_by { |retailer, infos| infos[:emissions] }
    # raise
    @top_basket = @basket[0]
  end

  def destroy
    @wish_list_item = WishListItem.find(params[:id])
    @wish_list_item.destroy
    render :destroy
  end

  def plus_amount
    @wish_list_item = WishListItem.find(params[:id])
    @wish_list_item.amount += 1
    @wish_list_item.save
    render :plus_amount
  end

  def minus_amount
    @wish_list_item = WishListItem.find(params[:id])
    @wish_list_item.amount -= 1
    @wish_list_item.save
    if @wish_list_item.amount < 1
      @wish_list_item.destroy
    end
    render :minus_amount
  end

  private
  def basket_params
    # raise
    params.require(:wish_list_item).permit(:basket, :retailer)
  end

  def wish_list_item_params
    params.require(:wish_list_item).permit(:item_id, :amount)
  end
end
