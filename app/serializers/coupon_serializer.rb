class CouponSerializer
  include JSONAPI::Serializer
  attributes :name, :code, :percent, :discount, :merchant_id, :invoice_id, :active
end
