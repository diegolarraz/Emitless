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
    required_amount = basket_item_in.calculate_swap(basket_item_out)

    @basket_item = BasketItem.new(item_id: params[:swap_in].to_i, amount: required_amount)
    @basket_item.basket = @basket
    @basket_item.save
    @basket.price -= basket_item_out.amount * basket_item_out.item.price
    @basket.price += @basket_item.item.price * @basket_item.amount
    @basket.emissions -= basket_item_out.amount * basket_item_out.item.emission
    @basket.emissions += @basket_item.item.emission * @basket_item.amount
    @old_item = basket_item_out
    BasketItem.destroy(basket_item_out.id)
    if @basket.save
      redirect_to basket_path(id: @basket)
    end
  end


end
