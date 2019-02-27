class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.references :user, foreign_key: true
      t.decimal :discount_amount
      t.decimal :discount_quantity

      t.timestamps
    end
  end
end
