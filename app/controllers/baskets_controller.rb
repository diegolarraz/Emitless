class BasketsController < ApplicationController
  def show
    if params[:format]
      @final_basket = Basket.find(params[:format])
    else
      @final_basket = Basket.new(retailer: params[:retailer], user: current_user)
      @final_basket.emissions = params[:basket][:emissions].to_f
      @final_basket.price = params[:basket][:price].to_f

      @final_basket.save

      items = params[:basket][:items]

      items.each do |generic_name, infos|
        item = BasketItem.create(item: Item.find(infos[1].to_i), basket: @final_basket, amount: infos[0].to_i)
      end

    end
  end

  def update
    @basket = Basket.find(params[:id])
    basket_item_out = @basket.basket_items.where("item_id = ?", params[:swap_out])
    basket_item_in = Item.find(params[:swap_in])
    # raise

    @basket_item = BasketItem.new(item_id: params[:swap_in].to_i, amount: basket_item_out[0].amount)
    @basket_item.basket = @basket
    @basket_item.save
    # raise
    BasketItem.destroy(basket_item_out[0].id)
    # raise
    # SWAP THOSE ITEMS B
    if @basket.save
      # raise
      redirect_to basket_path(@basket)
    end

    # remember to update emissions and prices of the final_basket when doing a swap
  end


end
