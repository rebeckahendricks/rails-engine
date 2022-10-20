class Api::V1::Merchants::SearchController < ApplicationController
  def index
    merchants = Merchant.find_all_by_name(params[:name])
    render json: MerchantSerializer.new(merchants)
  end

  def show
    merchant = Merchant.find_by_name(params[:name])
    if merchant
      render json: MerchantSerializer.new(merchant)
    else
      render json: ErrorSerializer.no_search_results
    end
  end
end
