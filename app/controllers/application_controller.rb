class ApplicationController < ActionController::API
  before_action :name_and_price
  before_action :negative_number

  def name_and_price
    if (params[:name] && params[:min_price]) || (params[:name] && params[:max_price])
      render json: ErrorSerializer.name_and_price_error, status: 400
    end
  end

  def negative_number
    if params[:min_price].to_i.negative? || params[:max_price].to_i.negative?
      render json: ErrorSerializer.negative_number_error, status: 400
    end
  end
end
