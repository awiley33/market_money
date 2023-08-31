require "rails_helper"

describe "Vendors API" do
  before do
    create_list(:vendor, 6)
    @vendor_1 = Vendor.all[0]
    @vendor_2 = Vendor.all[1]
    @vendor_3 = Vendor.all[2]
    @vendor_4 = Vendor.all[3]
    @vendor_5 = Vendor.all[4]
    @vendor_6 = Vendor.all[5]
  end

  describe "get one vendor" do
    it "returns JSON object with attrs if valid id is passed" do
      get "/api/v0/vendors/#{@vendor_1.id}"

      expect(response).to be_successful
      
      vendor = JSON.parse(response.body, symbolize_names: true)

        expect(vendor[:data]).to have_key(:id)
        expect(vendor[:data][:id]).to be_a(String)

        expect(vendor[:data][:attributes]).to have_key(:name)
        expect(vendor[:data][:attributes][:name]).to be_a(String)

        expect(vendor[:data][:attributes]).to have_key(:description)
        expect(vendor[:data][:attributes][:description]).to be_a(String)

        expect(vendor[:data][:attributes]).to have_key(:contact_name)
        expect(vendor[:data][:attributes][:contact_name]).to be_a(String)

        expect(vendor[:data][:attributes]).to have_key(:contact_phone)
        expect(vendor[:data][:attributes][:contact_phone]).to be_a(String)

        expect(vendor[:data][:attributes]).to have_key(:credit_accepted)
        expect(vendor[:data][:attributes][:credit_accepted]).to be_in([true, false])
    end

    xit "returns 404 status and descriptive error message if invalid id is passed" do
      id = 123123123123123
      get "/api/v0/vendors/#{id}"

      expect(response).to be_successful
      expect{Vendor.find(id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end