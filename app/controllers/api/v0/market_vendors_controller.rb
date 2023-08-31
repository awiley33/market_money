class Api::V0::MarketVendorsController < ApplicationController
  def index
    render json: VendorSerializer.new(Market.find(params[:market_id]).vendors)
  end
end