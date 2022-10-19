class Api::V1::Items::SearchController < ApplicationController
  def show
    items = Item.search_by_name(params[:name])
    render json: ItemSerializer.new(items)
  end
end