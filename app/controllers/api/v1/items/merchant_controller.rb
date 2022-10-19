class Api::V1::Items::MerchantController < ApplicationController
  def show
    item = Item.find(params[:item_id])
    merchant = item.merchant
    render json: MerchantSerializer.new(merchant)
  end
end
