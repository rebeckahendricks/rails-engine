class Api::V1::Merchants::SearchController < ApplicationController
  def show
    merchant = Merchant.search_by_name(params[:name])
    render json: MerchantSerializer.new(merchant)
  end
end