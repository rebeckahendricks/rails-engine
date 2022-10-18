class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    render json: ItemSerializer.new(Item.create(item_params)), status: 201
  end

  def update
    if Merchant.good_id?(item_params[:merchant_id])
      render json: ItemSerializer.new(Item.update(params[:id], item_params))
    else
      render status: 400
    end
  end

  def destroy
    render json: Item.delete(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:merchant_id, :name, :description, :unit_price)
  end
end
