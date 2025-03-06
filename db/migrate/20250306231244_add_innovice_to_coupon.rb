class AddInnoviceToCoupon < ActiveRecord::Migration[7.1]
  def change
    add_reference :coupons, :invoice, null: true, foreign_key: true
  end
end
