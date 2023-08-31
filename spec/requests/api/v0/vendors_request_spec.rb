require "rails_helper"

describe "Vendors API" do
  describe "get one vendor" do
    it "returns JSON object with attrs if valid id is passed" do
      vendor = create(:vendor)

      get "/api/v0/vendors/#{vendor.id}"

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

    it "returns 404 status and descriptive error message if invalid id is passed" do
      id = 123123123123
      get "/api/v0/vendors/#{id}"

      expect(response.status).to eq(404)
      expect{Vendor.find(id)}.to raise_error(ActiveRecord::RecordNotFound)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=123123123123")
    end
  end

  describe "create a vendor" do
    describe "happy path" do
      it "returns newly created vendor resource and a 201 code" do
        headers = {"CONTENT_TYPE" => "application/json"}
        vendor_params = ({
          "name": "Buzzy Bees",
          "description": "local honey and wax products",
          "contact_name": "Kimberly Couwer",
          "contact_phone": "8389928383",
          "credit_accepted": false
                        })
                        
        post "/api/v0/vendors", headers: headers, params: vendor_params, as: :json

        created_vendor = Vendor.last
        expect(response).to be_successful
        expect(response.status).to eq(201)

        expect(created_vendor.name).to eq(vendor_params[:name])
        expect(created_vendor.description).to eq(vendor_params[:description])
        expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
        expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
        expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
      end
    end

    describe "sad path, invalid or missing params" do
      it "does not create a new vendor, returns status code 400" do
        headers = {"CONTENT_TYPE" => "application/json"}
        vendor_params = ({
          "name": "Buzzy Bees",
          "description": "local honey and wax products",
          "credit_accepted": false
        })
        
        expect{ post "/api/v0/vendors", headers: headers, params: vendor_params, as: :json }.to_not change(Vendor, :count)
        post "/api/v0/vendors", headers: headers, params: vendor_params, as: :json
      
        data = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(400)
        expect(data[:errors].first[:status]).to eq("400")
        expect(data[:errors].first[:title]).to eq("Validation failed: Contact name can't be blank, Contact phone can't be blank")
      end
    end
  end

  describe "update a vendor" do
    it "updates an existing vendor with any parameters sent in via the body" do
      id = create(:vendor).id
      previous_contact_name = Vendor.last.contact_name
      vendor_params = { "contact_name": "Anna Wiley" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v0/vendors/#{id}", headers: headers, params: vendor_params, as: :json
      vendor = Vendor.find_by(id: id)

      expect(response).to have_http_status(200)
      expect(vendor.contact_name).to_not eq(previous_contact_name)
      expect(vendor.contact_name).to eq("Anna Wiley")
    end

    it "will raise a 404 error when invalid id is passed in" do
      id = 123123123123
      vendor_params = { "contact_name": "Anna Wiley" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v0/vendors/#{id}", headers: headers, params: vendor_params, as: :json

      expect(response).to_not be_successful
      expect(response).to have_http_status(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_an(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=123123123123")
    end

    it "will raise a 400 error when invalid params are passed in" do
      id = create(:vendor).id
      previous_contact_name = Vendor.last.contact_name
      vendor_params = { "contact_name": "" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch "/api/v0/vendors/#{id}", headers: headers, params: vendor_params, as: :json
      vendor = Vendor.find_by(id: id)

      expect(response).to_not be_successful
      expect(response).to have_http_status(400)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_an(Array)
      expect(data[:errors].first[:status]).to eq("400")
      expect(data[:errors].first[:title]).to eq("Validation failed: Contact name can't be blank")
    end
  end

  describe "delete a vendor" do
    it "will destroy the vendor, as well as any associations that vendor had, and return a 204 status code" do
    vendor = create(:vendor)
    id = vendor.id
    expect{ delete "/api/v0/vendors/#{vendor.id}" }.to change(Vendor, :count).by(-1)

    delete "/api/v0/vendors/#{vendor.id}"
    
    expect{Vendor.find(id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "will raise a 404 error when invalid id is passed in" do
      id = 123123123123

      delete "/api/v0/vendors/#{id}"

      expect(response).to_not be_successful
      expect(response).to have_http_status(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_an(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=123123123123")
    end
  end
end