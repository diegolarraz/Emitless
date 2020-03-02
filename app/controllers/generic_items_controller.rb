class GenericItemsController < ApplicationController
  def index
    @generic_items = GenericItem.all
  end

  def show
    @generic_item = GenericItem.find(params[:id])
  end
end
