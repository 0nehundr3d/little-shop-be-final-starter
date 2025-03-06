class Coupon < ApplicationRecord
    belongs_to: :merchant
    belongs_to: :innovice, optional: true
end