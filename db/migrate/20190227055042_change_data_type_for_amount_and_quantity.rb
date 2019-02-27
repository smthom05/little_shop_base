class ChangeDataTypeForAmountAndQuantity < ActiveRecord::Migration[5.1]
  def change
    change_column :discounts, :discount_amount, :integer
    change_column :discounts, :discount_quantity, :integer
  end
end
