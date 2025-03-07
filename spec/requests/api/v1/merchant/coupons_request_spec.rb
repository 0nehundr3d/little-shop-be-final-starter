require "rails_helper"

describe "Coupons endpoints", :type => :request do
    describe "GET all coupons" do
        it "should return a list of coupons" do
            merchant = create(:merchant)
            create_list(:coupon, 3, merchant: merchant)

            get "/api/v1/merchants/#{merchant.id}/coupons"
            json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:ok)
            expect(json[:data].count).to eq(3)
            expect(json[:data].first).to include(:id, :type, :attributes)
            expect(json[:data].first[:attributes]).to include(:name, :code, :dollar_off, :percent_off, :merchant_id, :active)
        end
    end
    
    describe "GET one coupon" do
        it "should return info about a specific coupon" do
            merchant = create(:merchant)
            coupon = create(:coupon, merchant: merchant)
            
            get "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}"
            json = JSON.parse(response.body, symbolize_names: true)
            
            expect(response).to have_http_status(:ok)
            expect(json[:data]).to include(:id, :type, :attributes)
            expect(json[:data][:attributes]).to include(:name, :code, :dollar_off, :percent_off, :merchant_id, :active)
        end 

        it "Should return a 404 error when searching for non existant merchant" do
            merchant = create(:merchant)
            coupon = create(:coupon, merchant: merchant)

            get "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id + 1}"
            json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:not_found)
        end
    end

    describe "POST a coupon" do
        it "should create a coupon when all params are present" do
            merchant = create(:merchant)
            body = {
                name: "Test Coupon",
                code: "Test",
                percent_off: "12",
                merchant_id: merchant.id
            }

            post "/api/v1/merchants/#{merchant.id}/coupons", params: body, as: :json
            json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:ok)
            expect(json[:data][:attributes][:name]).to eq(body[:name])
            expect(json[:data][:attributes][:code]).to eq(body[:code])
            expect(json[:data][:attributes][:percent_off]).to eq(body[:percent_off].to_i)
            expect(json[:data][:attributes][:merchant_id]).to eq(body[:merchant_id].to_i)
            expect(json[:data][:attributes][:active]).to eq(true)
        end
    end

    describe "UPDATE a coupon" do
        it "should update a specific coupon" do
            merchant = create(:merchant)
            coupon = create(:coupon, merchant: merchant)

            body = {
                active: false,
                name: "Test Change"
            }

            patch "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}", params: body, as: :json
            json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:ok)

            expect(json[:data][:id]).to eq(coupon.id.to_s)
            expect(json[:data][:attributes][:active]).to eq(body[:active])
            expect(json[:data][:attributes][:name]).to eq(body[:name])
        end
    end
end