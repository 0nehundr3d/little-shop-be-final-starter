class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.boolean :percent, default: false
      t.integer :discount
      t.references :merchant, null: false, foreign_key: true
      t.references :invoice, null: true, foreign_key: true

      t.timestamps
    end
  end
end
