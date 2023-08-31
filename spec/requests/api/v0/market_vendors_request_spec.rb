require "rails_helper"

describe "MarketVendors API" do
  before do
    create_list(:market, 3)
    @market_1 = Market.all[0]
    @market_2 = Market.all[1]
    @market_3 = Market.all[2]

    create_list(:vendor, 6)
    @vendor_1 = Vendor.all[0]
    @vendor_2 = Vendor.all[1]
    @vendor_3 = Vendor.all[2]
    @vendor_4 = Vendor.all[3]
    @vendor_5 = Vendor.all[4]
    @vendor_6 = Vendor.all[5]

    MarketVendor.create!(market_id: @market_1.id, vendor_id: @vendor_1.id)
    MarketVendor.create!(market_id: @market_1.id, vendor_id: @vendor_2.id)
    MarketVendor.create!(market_id: @market_1.id, vendor_id: @vendor_3.id)
    MarketVendor.create!(market_id: @market_1.id, vendor_id: @vendor_4.id)
    MarketVendor.create!(market_id: @market_2.id, vendor_id: @vendor_4.id)
    MarketVendor.create!(market_id: @market_2.id, vendor_id: @vendor_6.id)
  end

  describe "get all vendors for a market" do
    it "returns a collection of vendors and their attributes when valid id passed" do
      get "/api/v0/markets/#{@market_1.id}/vendors"

      expect(response).to be_successful
      
      vendors = JSON.parse(response.body, symbolize_names: true)

      vendors[:data].each do |vendor|
        expect(vendor).to have_key(:id)
        expect(vendor[:id]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:name)
        expect(vendor[:attributes][:name]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:description)
        expect(vendor[:attributes][:description]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:contact_name)
        expect(vendor[:attributes][:contact_name]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:contact_phone)
        expect(vendor[:attributes][:contact_phone]).to be_a(String)

        expect(vendor[:attributes]).to have_key(:credit_accepted)
        expect(vendor[:attributes][:credit_accepted]).to be_in([true, false])
      end
    end
    
    xit "returns an error message when invalid id passed" do

    end
  end
end