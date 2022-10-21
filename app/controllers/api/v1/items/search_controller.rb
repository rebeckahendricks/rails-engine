class Api::V1::Items::SearchController < ApplicationController
  def index
    if params[:name]
      items = Item.find_all_by_name(params[:name])
    elsif params[:min_price] || params[:max_price]
      items = Item.find_all_by_price(min_price: params[:min_price], max_price: params[:max_price])
    end
    render json: ItemSerializer.new(items)
  end

  def show
    if params[:name]
      item = Item.find_by_name(params[:name])
    elsif params[:min_price] || params[:max_price]
      item = Item.find_by_price(min_price: params[:min_price], max_price: params[:max_price])
    end

    if item
      render json: ItemSerializer.new(item)
    else
      render json: ErrorSerializer.no_search_results
    end
  end
end
