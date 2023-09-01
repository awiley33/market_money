require "rails_helper"

RSpec.describe Market, type: :model do
  describe "Associations" do
    it {should have_many :market_vendors}
    it {should have_many(:vendors).through(:market_vendors)}
  end

  describe "Validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :street }
    it { should validate_presence_of :city }
    it { should validate_presence_of :county }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :lat }
    it { should validate_presence_of :lon }
  end

  describe "Instance Methods"
    describe "#vendor_count" do
      it "returns the number of vendors associated with a market instance" do
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

        expect(@market_1.vendor_count).to eq(4)
        expect(@market_2.vendor_count).to eq(2)
        expect(@market_3.vendor_count).to eq(0)
      end
    end
end