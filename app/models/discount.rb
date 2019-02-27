class Discount < ApplicationRecord
  belongs_to :user, foreign_key: 'user_id'

  validates :discount_amount, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  validates :discount_quantity, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  def self.discount_deleter(merchant)
    where(user_id: merchant.id).delete_all
  end
end
