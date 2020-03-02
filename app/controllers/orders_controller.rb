class OrdersController < ApplicationController
  def index
    @orders =Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @oder = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to orders_path
    else
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order.update(order_params)
    if @order.save
      flash[:notice] = "Your order has been successfully edited!"
      redirect_to "download"
    else
      render :show
    end
  end

  private

  def order_params

  end
end
