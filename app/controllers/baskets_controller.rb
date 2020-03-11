class BasketsController < ApplicationController
  def show
    if params["format"] == "pdf"
      @final_basket = Basket.find(params["basket"])
    elsif params[:id]
      @final_basket = Basket.find(params[:id].to_i)
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
        # {"basket"=>"24", "retailer"=>"tesco", "format"=>"pdf"


    respond_to do |format|
      format.html
      format.pdf do
          render pdf: "file.pdf",
          page_size: 'A4',
          template: "baskets/show.html.erb",
          layout: "pdf.html",
          orientation: "landscape",
          encoding:"UTF-8"
      end
    end
  end

  def update
    @basket = Basket.find(params[:id])
    basket_item_out = @basket.basket_items.where("item_id = ?", params[:swap_out])[0]
    basket_item_in = Item.find(params[:swap_in])
    # raise
    desired_quantity = basket_item_out.item.quantity.to_f * basket_item_out.amount.to_i
    if basket_item_in.unit == basket_item_out.item.unit
      required_amount = desired_quantity / basket_item_in.quantity.to_i
      # raise
    elsif basket_item_in.unit == "g" && basket_item_out.item.unit == "kg"
      # raise
      required_amount = desired_quantity * 1000 / basket_item_in.quantity.to_i
      # raise
    elsif basket_item_in.unit == "kg" && basket_item_out.item.unit == "g"
      required_amount = desired_quantity / 1000 / basket_item_in.quantity.to_i
    elsif basket_item_in.unit == "each" && basket_item_out.item.unit != "each"
      if basket_item_in.category == "fruit"
        required_amount = desired_quantity / 100
      # raise
      elsif basket_item_in.category == "vegetable"
        required_amount = desired_quantity / 250
        # raise
      elsif basket_item_in.category == ("meat" || "seafood")
        required_amount = desired_quantity / 150
        # raise
      end
    else
      raise
      # raise
    end
    # raise
    @basket_item = BasketItem.new(item_id: params[:swap_in].to_i, amount: required_amount)
    if @basket_item.amount == 0
      raise
    end
    @basket_item.basket = @basket
    @basket_item.save
    # raise
    @basket.price -= basket_item_out.amount * basket_item_out.item.price
    @basket.price += @basket_item.item.price * @basket_item.amount
    @basket.emissions -= basket_item_out.amount * basket_item_out.item.emission
    @basket.emissions += @basket_item.item.emission * @basket_item.amount
    BasketItem.destroy(basket_item_out.id)
    # raise
    # SWAP THOSE ITEMS B
    if @basket.save
      # raise
      # raise
      redirect_to basket_path(id: @basket)
    end

    # remember to update emissions and prices of the final_basket when doing a swap
  end


end
