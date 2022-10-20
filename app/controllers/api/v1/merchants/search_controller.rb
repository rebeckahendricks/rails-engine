class Api::V1::Merchants::SearchController < ApplicationController
  def show
    merchant = Merchant.search_by_name(params[:name])
    if merchant
      render json: MerchantSerializer.new(merchant)
    else
      render json: ErrorSerializer.no_search_results
    end
  end
end