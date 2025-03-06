require "rails_helper"

describe "Coupons endpoints", :type => :request do
    describe "GET all coupons" do
        it "should return a list of coupons" do
            create_list(:coupon, 3, merchant: create(:merchant))

            get "/api/v1/coupons"
            json = JSON.parse(response.body, symbolize_names: true)

            expect(respond).to have_http_status(:ok)
            expect(json[:data].count).to eq(3)
            expect(json[:data].first).to include(:id, :type, :attributes)
            expect(json[:data].first[:attributes]).to incude(:name, :code, :dollar_off, :percent_off, :merchant)
        end
    end
end