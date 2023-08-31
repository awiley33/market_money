class Api::V0::MarketVendorsController < ApplicationController
  def index
    render json: VendorSerializer.new(Market.find(params[:market_id]).vendors)
  end

  def create
    render json: MarketVendorSerializer.new(MarketVendor.create!(market_vendor_params)), status: 201
  end

  private

  def market_vendor_params
    params.permit(:market_id, :vendor_id)
  end
end