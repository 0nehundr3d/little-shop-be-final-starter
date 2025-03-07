require "rails_helper"
require 'pry'

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
            expect(json[:data].first[:attributes]).to include(:name, :code, :percent, :discount, :merchant_id, :active)
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
            expect(json[:data][:attributes]).to include(:name, :code, :percent, :discount, :merchant_id, :active)
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
                discount: "12",
                merchant_id: merchant.id
            }

            post "/api/v1/merchants/#{merchant.id}/coupons", params: body, as: :json
            json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:ok)
            expect(json[:data][:attributes][:name]).to eq(body[:name])
            expect(json[:data][:attributes][:code]).to eq(body[:code])
            expect(json[:data][:attributes][:discount]).to eq(body[:discount].to_i)
            expect(json[:data][:attributes][:merchant_id]).to eq(body[:merchant_id].to_i)
            expect(json[:data][:attributes][:active]).to eq(true)
        end

        it "should require a name to be created" do
            merchant = create(:merchant)
            body = {
                code: "Test",
                discount: "12",
                merchant_id: merchant.id
            }

            post "/api/v1/merchants/#{merchant.id}/coupons", params: body, as: :json
            json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should require a code to be created" do
            merchant = create(:merchant)
            body = {
                name: "Test",
                discount: "12",
                merchant_id: merchant.id
            }

            post "/api/v1/merchants/#{merchant.id}/coupons", params: body, as: :json
            json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should require a discount to be created" do
            merchant = create(:merchant)
            body = {
                name: "Test",
                code: "Test",
                merchant_id: merchant.id
            }

            post "/api/v1/merchants/#{merchant.id}/coupons", params: body, as: :json
            json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should require a unique code to be created" do
            merchant1 = create(:merchant)
            merchant2 = create(:merchant)

            body1 = {
                name: "Test",
                code: "Test",
                discount: 10,
                merchant_id: merchant1.id
            }
            body2 = {
                name: "Test",
                code: "Test",
                discount: 10,
                merchant_id: merchant1.id
            }

            post "/api/v1/merchants/#{merchant1.id}/coupons", params: body1, as: :json
            post "/api/v1/merchants/#{merchant2.id}/coupons", params: body2, as: :json
            json = JSON.parse(response.body, symbolize_names: true)

            # binding.pry
            expect(response).to have_http_status(:unprocessable_entity)
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

        it "should not allow updating to an already taken coupon code" do
            merchant = create(:merchant)
            coupons = create_list(:coupon, 2, merchant: merchant)

            body = {
                code: coupons[0].code
            }

            patch "/api/v1/merchants/#{merchant.id}/coupons/#{coupons[1].id}", params: body, as: :json
            
            json = JSON.parse(response.body, symbolize_names: true)
            expect(response).to have_http_status(:unprocessable_entity)
        end

        it "should return a 404 when merchant id is not found" do
            merchant = create(:merchant)
            coupon = create(:coupon, merchant: merchant)

            body = {
                active: false,
                name: "Test Change"
            }

            patch "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id + 1}", params: body, as: :json
            json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:not_found)
        end

        it "should retuan a 400 when trying to make a 5th coupon active" do
            merchant = create(:merchant)
            active_coupons = create_list(:coupon, 5, merchant: merchant)
            inactive_coupon = create(:coupon, active: false, merchant: merchant)

            body = {
                active: true
            }

            patch "/api/v1/merchants/#{merchant.id}/coupons/#{inactive_coupon.id}", params: body, as: :json
            json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(400)
            expect(json[:errors][0]).to eq("Can not activeate more than 5 coupons at one time")
        end
    end
end