require "rails_helper"

describe "Markets API" do
  before do
    create_list(:market, 3)
  end
  it "sends a list of markets" do
    get '/api/v0/markets'
    
    expect(response).to be_successful
    # require 'pry'; binding.pry
    markets = JSON.parse(response.body, symbolize_names: true)

    markets.each do |market|
      expect(market).to have_key(:id)
      expect(market[:id]).to be_an(Integer)

      expect(market).to have_key(:name)
      expect(market[:name]).to be_a(String)

      expect(market).to have_key(:street)
      expect(market[:street]).to be_a(String)

      expect(market).to have_key(:city)
      expect(market[:city]).to be_a(String)

      expect(market).to have_key(:county)
      expect(market[:county]).to be_a(String)

      expect(market).to have_key(:state)
      expect(market[:state]).to be_a(String)

      expect(market).to have_key(:zip)
      expect(market[:zip]).to be_a(String)

      expect(market).to have_key(:lon)
      expect(market[:lon]).to be_a(String)

      expect(market).to have_key(:lat)
      expect(market[:lat]).to be_a(String)

      # expect(market).to have_key(:vendor_count)
      # expect(market[:lat]).to be_an(Integer)
    end
  end
end