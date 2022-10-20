class Api::V1::Items::SearchController < ApplicationController
  def index
    if params[:name]
      items = Item.search_by_name(params[:name])
    elsif params[:min_price] || params[:max_price]
      items = Item.search_by_price(min_price: params[:min_price], max_price: params[:max_price])
    end
    render json: ItemSerializer.new(items)
  end
end
