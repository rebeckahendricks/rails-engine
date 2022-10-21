class ApplicationController < ActionController::API
  before_action :name_and_price
  before_action :negative_number
  before_action :no_search_input
  before_action :min_max_price

  def name_and_price
    return unless (params[:name] && params[:min_price]) || (params[:name] && params[:max_price])

    render json: ErrorSerializer.name_and_price_error, status: 400
  end

  def negative_number
    return unless params[:min_price].to_f.negative? || params[:max_price].to_f.negative?

    render json: ErrorSerializer.negative_number_error, status: 400
  end

  def no_search_input
    return unless params[:name] == '' || params[:min_price] == '' || params[:max_price] == ''

    render json: ErrorSerializer.no_search_input_error, status: 400
  end

  def min_max_price
    return unless (params[:min_price] && params[:max_price]) && (params[:min_price].to_f > params[:max_price].to_f)

    render json: ErrorSerializer.min_max_price_error, status: 400
  end
end
