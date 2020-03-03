class GenericItemsController < ApplicationController
  def index
    if params[:query].present?
      @generic_items = GenericItem.where(name: params[:query].downcase)
    else
      @generic_items = GenericItem.all
    end
  end

  def show
    @generic_item = GenericItem.find(params[:id])
  end
end
