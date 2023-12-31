class Api::V0::VendorsController < ApplicationController
  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  def create
    render json: VendorSerializer.new(Vendor.create!(new_vendor_params)), status: 201
  end

  def update
    vendor = Vendor.find(params[:id])
    vendor.update!(vendor_params)
    render json: VendorSerializer.new(vendor)
  end

  def destroy
    vendor = Vendor.find(params[:id])
    vendor.destroy!
    render json: VendorSerializer.new(vendor), status: 204
  end

  private

  def new_vendor_params
    params.permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end