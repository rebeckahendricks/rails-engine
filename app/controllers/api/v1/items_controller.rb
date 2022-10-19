class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(Item.create(item_params)), status: 201
    else
      render status: 400
    end
  end

  def update
    if Merchant.good_id?(item_params[:merchant_id])
      render json: ItemSerializer.new(Item.update(params[:id], item_params))
    else
      render status: 400
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.invoice_items.each do |invoice_item|
      invoice_item.destroy
    end
    Item.delete(item)
  end

  private

  def item_params
    params.require(:item).permit(:merchant_id, :name, :description, :unit_price)
  end
end
