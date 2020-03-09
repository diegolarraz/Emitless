class BasketsController < ApplicationController
  def show
    @final_basket = Basket.new(retailer: params[:retailer], user: current_user)
    @final_basket.emissions = params[:basket][:emissions].to_f
    @final_basket.price = params[:basket][:price].to_f

    @final_basket.save

    items = params[:basket][:items]

    items.each do |generic_name, infos|
      item = BasketItem.create(item: Item.find(infos[1].to_i), basket: @final_basket, amount: infos[0].to_i)
    end

  end

  def update
    # SWAP THOSE ITEMS BRO

    # remember to update emissions and prices of the final_basket when doing a swap
  end
end
