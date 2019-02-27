require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'validations' do
    it { should validate_presence_of :discount_amount }
    it { should validate_presence_of :discount_quantity }
    it { should validate_numericality_of(:discount_amount).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:discount_quantity).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:discount_amount).only_integer }
    it { should validate_numericality_of(:discount_quantity).only_integer }
  end

  describe 'relationships' do
    it { should belong_to :user }
  end

  describe 'class methods' do
    it '.discount_deleter' do
      merchant = create(:merchant)
      merchant_2 = create(:merchant)
      discount_1 = merchant.discounts.create(discount_amount: 100, discount_quantity: 500)
      discount_2 = merchant.discounts.create(discount_amount: 50, discount_quantity: 600)
      discount_3 = merchant.discounts.create(discount_amount: 200, discount_quantity: 700)
      discount_4 = merchant_2.discounts.create(discount_amount: 2110, discount_quantity: 7400)

      expect(merchant.discounts.count).to eq(3)
      expect(merchant_2.discounts.count).to eq(1)

      Discount.discount_deleter(merchant)

      expect(merchant.discounts.count).to eq(0)
      expect(merchant_2.discounts.count).to eq(1)
    end
  end

end
