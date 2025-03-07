require "rails_helper"

describe "Coupons endpoints", :type => :request do
    describe "GET coupons" do
        it "should return a list of coupons" do
            merchant = create(:merchant)
            create_list(:coupon, 3, merchant: merchant)

            get "/api/v1/merchants/#{merchant.id}/coupons"
            json = JSON.parse(response.body, symbolize_names: true)

            expect(response).to have_http_status(:ok)
            expect(json[:data].count).to eq(3)
            expect(json[:data].first).to include(:id, :type, :attributes)
            expect(json[:data].first[:attributes]).to include(:name, :code, :dollar_off, :percent_off, :merchant_id)
        end

        it "should return info about a specific coupon" do
            merchant = create(:merchant)
            coupon = create(:coupon, merchant: merchant)

            get "/api/v1/merchants/#{merchant.id}/coupons/#{coupon.id}"
            json = JSON.parse(response.body, symbolize_names: true)

            expect(response).ti have_http_status(:ok)
            expect(json[:data].first).to include(:id, :type, :attributes)
            expect(json[:data].first[:attributes]).to include(:name, :code, :dollar_off, :percent_off, :merchant_id)
        end
    end
end