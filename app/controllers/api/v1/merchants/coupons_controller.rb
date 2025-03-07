class Api::V1::Merchants::CouponsController < ApplicationController
    def index
        merchant = Merchant.find(params[:merchant_id])
        render json: CouponSerializer.new(merchant.coupons)
    end

    def show
        merchant = Merchant.find(params[:merchant_id])
        render json: CouponSerializer.new(merchant.coupons.find(params[:id]))
    end

    def create 
        coupon = Coupon.create!(coupon_params)
        render json: CouponSerializer.new(coupon)
    end

    def update
        coupon = Coupon.find(params[:id])
        
        if params[:active] && Coupon.check_active_coupons(params[:merchant_id])
            return render json: {
                message: "Your update could not be made",
                errors: ["Can not activate more than 5 coupons at one time"]
            }, status: 400
        end
        
        coupon.update!(coupon_params)
        render json: CouponSerializer.new(coupon)
    end

    private 

    def coupon_params
        params.permit(:name, :code, :discount, :percent, :merchant_id, :active)
    end
end