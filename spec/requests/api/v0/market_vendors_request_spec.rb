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
      expect(response).to have_http_status(200)

      
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
    
    it "returns an error message when invalid id passed" do
      id = 123123123123
      get "/api/v0/markets/#{id}/vendors"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_an(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Market with 'id'=123123123123")
    end
  end

  describe "create a MarketVendor" do
    it "" do
      headers = {"CONTENT_TYPE" => "application/json"}
      params = {
                "market_id": @market_1.id,
                "vendor_id": @vendor_5.id
              }

      post "/api/v0/market_vendors", headers: headers, params: params, as: :json

      market_vendor = MarketVendor.last
      expect(response).to be_successful
      expect(response.status).to eq(201)

      expect(market_vendor.market_id).to eq(params[:market_id])
      expect(market_vendor.vendor_id).to eq(params[:vendor_id])
        
      # get "/api/v0/markets/#{@market_1.id}/vendors"

      # vendors = JSON.parse(response.body, symbolize_names: true)

      # expect(vendors).to include(@vendor_5.name)
    end
  end
end