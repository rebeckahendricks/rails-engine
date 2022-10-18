class Api::V1::ItemsMerchantController < ApplicationController
  def show
    item = Item.find(params[:item_id])
    merchant = item.merchant
    render json: MerchantSerializer.new(merchant)
  end
end
