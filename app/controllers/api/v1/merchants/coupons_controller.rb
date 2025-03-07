class Api::V1::Merchants::CouponsController < ApplicationController
    def index
        merchant = Merchant.find(params[:merchant_id])
        render json: CouponSerializer.new(merchant.coupons)
    end

    def show
        merchant = Merchant.find(params[:merchant_id])
        render json: CouponSerializer.new(merchant.coupons.find(params[:id]))
    end
end