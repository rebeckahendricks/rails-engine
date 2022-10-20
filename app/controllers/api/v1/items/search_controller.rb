class Api::V1::Items::SearchController < ApplicationController
  def show
    if params[:name] && params[:min_price]
      render json: ItemSerializer.negative_price, status: 400
    # elsif params[:name] && params[:max_price]
    #   render json: ItemSerializer.negative_price, status: 400
    elsif params[:name]
      items = Item.search_by_name(params[:name])
      render json: ItemSerializer.new(items)
    elsif params[:min_price] && params[:max_price]
      items = Item.search_by_price(params[:min_price], params[:max_price])
      render json: ItemSerializer.new(items)
    elsif params[:min_price]
      if params[:min_price].to_i.negative?
        render json: ItemSerializer.negative_price, status: 400
      else
        items = Item.search_by_price(params[:min_price])
        render json: ItemSerializer.new(items)
      end
    # elsif params[:max_price]
    #   if params[:max_price].to_i.negative?
    #     render json: ItemSerializer.negative_price, status: 400
    #   else
    #     items = Item.search_by_price(0, params[:max_price])
    #     render json: ItemSerializer.new(items)
    #   end
    end
  end
end
