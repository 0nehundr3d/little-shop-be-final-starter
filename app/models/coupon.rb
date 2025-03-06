class Coupon < ApplicationRecord
    belongs_to :merchant
    belongs_to :invoice, optional: true
end