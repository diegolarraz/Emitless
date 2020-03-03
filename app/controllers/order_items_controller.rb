class OrderItemsController < ApplicationController
  def create(order_item_params)
  end

  private

  def order_item_params
    params.require[:generic_item].permit[:name]
  end
end
