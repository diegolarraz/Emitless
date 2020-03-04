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


    # all_item_instances = {}

    # @wish_list_items.each do |wish_list_item|
    #   all_item_instances[wish_list_item.item.generic_name] = Item.where(generic_name: wish_list_item.item.generic_name)
    # end

    # set_retailers(all_item_instances)

    # @tesco_basket = set_retailers[0]
    # @morrisons_basket = set_retailers[1]
    # @ocado_basket = set_retailers [2]



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

  def set_retailers(all_item_instances)
    @tesco_items = {}
    @morrisons_items = {}
    @ocado_items = {}

    all_item_instances.each do |generic_item, item_instances|
      @tesco_items[generic_item] = []
      @morrisons_items[generic_item] = []
      @ocado_items[generic_item] = []

      item_instances.each do |item_instance|
        case item_instance.retailer
        when "Tesco"
          @tesco_items[generic_item] << item_instance
        when "Morrisons"
          @morrisons_items[generic_item] << item_instance
        when "Ocado"
          @ocado_items[generic_item] << item_instance
        end
      end

      # @tesco_items[generic_item] = @tesco_items[generic_item].where

    query = "
            SELECT *
            FROM items
            WHERE generic_name = 'Macaroni'
            AND retailer = 'Tesco'
            ORDER BY emission DESC
            LIMIT 1
            "
    query2 = "SELECT *
          FROM items
          WHERE generic_name = 'macaroni'
          "

    resultat = Item.all.where(generic_name: "macaroni").where(retailer: "Tesco").order(emission: :asc).first

    raise




    return [@tesco_items, @morrisons_items, @ocado_items]
    end
  end
end
