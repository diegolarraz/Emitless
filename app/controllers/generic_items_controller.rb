class GenericItemsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :index]

  def index
    @generic_items = GenericItem.all
  end

  def show
    @generic_item = GenericItem.find(params[:id])
  end
end
