class Api::V1::CouponsController < ApplicationController
    def index
        render json: CouponSerializer.new(Coupon.all)
    end
end