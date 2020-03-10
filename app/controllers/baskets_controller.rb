class BasketsController < ApplicationController
  def show
      unless params["format"] == "pdf"
        @final_basket = Basket.new(retailer: params[:retailer], user: current_user)
        @final_basket.emissions = params[:basket][:emissions].to_f
        @final_basket.price = params[:basket][:price].to_f

        @final_basket.save

        items = params[:basket][:items]

        items.each do |generic_name, infos|
          item = BasketItem.create(item: Item.find(infos[1].to_i), basket: @final_basket, amount: infos[0].to_i)
        end
      else
        # {"basket"=>"24", "retailer"=>"tesco", "format"=>"pdf"}
        @final_basket = Basket.find(params["basket"])
      end


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
    # SWAP THOSE ITEMS BRO

    # remember to update emissions and prices of the final_basket when doing a swap
  end
end
