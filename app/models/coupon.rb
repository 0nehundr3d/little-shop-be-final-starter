class Coupon < ApplicationRecord
    validates :name, presence: true
    validates :code, presence: true, uniqueness: true
    validates :discount, presence: true

    belongs_to :merchant
    belongs_to :invoice, optional: true
end