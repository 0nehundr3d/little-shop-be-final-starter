class Coupon < ApplicationRecord
    validates :name, presence: true
    validates :code, presence: true, uniqueness: true
    validates :discount, presence: true

    belongs_to :merchant
    belongs_to :invoice, optional: true

    def self.check_active_coupons(merchant_id)
        return Coupon.where(:merchant_id => merchant_id).length >= 5
    end
end