class Api::V1::Items::SearchController < ApplicationController
  def show
    if params[:name]
      items = Item.search_by_name(params[:name])
    elsif params[:min_price] && params[:max_price]
      items = Item.search_by_price(params[:min_price], params[:max_price])
    elsif params[:min_price]
      items = Item.search_by_price(params[:min_price])
    elsif params[:max_price]
      items = Item.search_by_price(0, params[:max_price])
    end
    render json: ItemSerializer.new(items)
  end
end
