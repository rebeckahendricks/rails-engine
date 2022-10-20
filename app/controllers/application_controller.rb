class ApplicationController < ActionController::API
  before_action :name_and_price
  before_action :negative_number

  def name_and_price
    return unless (params[:name] && params[:min_price]) || (params[:name] && params[:max_price])

    render json: ErrorSerializer.name_and_price_error, status: 400
  end

  def negative_number
    return unless params[:min_price].to_f.negative? || params[:max_price].to_f.negative?

    render json: ErrorSerializer.negative_number_error, status: 400
  end
end
