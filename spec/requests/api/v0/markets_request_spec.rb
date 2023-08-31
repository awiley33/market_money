require "rails_helper"

describe "Markets API" do
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

  it "sends a list of markets" do
    get "/api/v0/markets"
    
    expect(response).to be_successful

    markets = JSON.parse(response.body, symbolize_names: true)

    expect(markets[:data].count).to eq(3)

    markets[:data].each do |market|
      expect(market).to have_key(:id)
      expect(market[:id]).to be_a(String)

      expect(market[:attributes]).to have_key(:name)
      expect(market[:attributes][:name]).to be_a(String)

      expect(market[:attributes]).to have_key(:street)
      expect(market[:attributes][:street]).to be_a(String)

      expect(market[:attributes]).to have_key(:city)
      expect(market[:attributes][:city]).to be_a(String)

      expect(market[:attributes]).to have_key(:county)
      expect(market[:attributes][:county]).to be_a(String)

      expect(market[:attributes]).to have_key(:state)
      expect(market[:attributes][:state]).to be_a(String)

      expect(market[:attributes]).to have_key(:zip)
      expect(market[:attributes][:zip]).to be_a(String)

      expect(market[:attributes]).to have_key(:lon)
      expect(market[:attributes][:lon]).to be_a(String)

      expect(market[:attributes]).to have_key(:lat)
      expect(market[:attributes][:lat]).to be_a(String)

      expect(market[:attributes]).to have_key(:vendor_count)
      expect(market[:attributes][:vendor_count]).to be_an(Integer)
    end
  end

  describe "get one market" do
    it "returns all market attrs with a valid id" do
      get "/api/v0/markets/#{@market_1.id}"
      
      expect(response).to be_successful
      expect(response).to have_http_status(200)

      
      market = JSON.parse(response.body, symbolize_names: true)

        expect(market[:data]).to have_key(:id)
        expect(market[:data][:id]).to be_a(String)

        expect(market[:data][:attributes]).to have_key(:name)
        expect(market[:data][:attributes][:name]).to be_a(String)

        expect(market[:data][:attributes]).to have_key(:street)
        expect(market[:data][:attributes][:street]).to be_a(String)

        expect(market[:data][:attributes]).to have_key(:city)
        expect(market[:data][:attributes][:city]).to be_a(String)

        expect(market[:data][:attributes]).to have_key(:county)
        expect(market[:data][:attributes][:county]).to be_a(String)

        expect(market[:data][:attributes]).to have_key(:state)
        expect(market[:data][:attributes][:state]).to be_a(String)

        expect(market[:data][:attributes]).to have_key(:zip)
        expect(market[:data][:attributes][:zip]).to be_a(String)

        expect(market[:data][:attributes]).to have_key(:lon)
        expect(market[:data][:attributes][:lon]).to be_a(String)

        expect(market[:data][:attributes]).to have_key(:lat)
        expect(market[:data][:attributes][:lat]).to be_a(String)

        expect(market[:data][:attributes]).to have_key(:vendor_count)
        expect(market[:data][:attributes][:vendor_count]).to be_an(Integer)
    end

    it "returns an error message when invalid id is passed" do
      id = 123123123123
      get "/api/v0/markets/#{id}"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_an(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Market with 'id'=123123123123")
    end
  end
end


# expect{Market.find(id)}.to raise_error(ActiveRecord::RecordNotFound)