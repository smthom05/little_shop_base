require 'rails_helper'

RSpec.describe 'User adds to the cart' do
  before :each do
    @merchant = create(:merchant)
    @user = create(:user)
    @item_1 = create(:item, price: 11, inventory: 50)
    @discount_1 = @merchant.discounts.create(discount_amount: 10, discount_quantity: 50)
    @discount_2 = @merchant.discounts.create(discount_amount: 20, discount_quantity: 100)
  end

  describe 'a user can add items to the cart and if they reach the discount threshold' do
    it 'will apply the discount in the cart' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit item_path(@item_1)

      click_button "Add to Cart"
      visit item_path(@item_1)
      click_button "Add to Cart"
      visit item_path(@item_1)
      click_button "Add to Cart"
      visit item_path(@item_1)
      click_button "Add to Cart"

      visit cart_path

      expect(page).to have_content("Subtotal: $44.00")

      visit item_path(@item_1)
      click_button "Add to Cart"

      visit cart_path

      expect(page).to have_content("Subtotal: $45.00")
    end
  end
end
