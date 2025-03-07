class Coupon < ApplicationRecord
    validates :name, presence: true
    belongs_to :merchant
    belongs_to :invoice, optional: true
end