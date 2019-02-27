require 'rails_helper'

RSpec.describe 'merchant can edit a discount', type: :feature do
  before :each do
    @merchant = create(:merchant)
    @discount_1 = @merchant.discounts.create(discount_amount: 11, discount_quantity: 55)
  end

  describe 'merchant has clicked edit discount link and arrived on the form for editing a discount' do
    it 'can fill out the form and edit the discount' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

    visit edit_dashboard_discount_path(@discount_1)

    fill_in "Discount amount", with: 10000
    fill_in "Discount quantity", with: 750

    click_button ("Update Discount")

    expect(page).to have_content("Successfully Updated Discount Number: #{@discount_1.id}")
    expect(page).to have_content("Required Spending: 750")
    expect(page).to have_content("Discounted Amount: 10000")

    expect(page).to_not have_content("Discounted Amount: 11")
    expect(page).to_not have_content("Required Spending: 55")
    end

    it 'cannot update the discount with missing amount' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit edit_dashboard_discount_path(@discount_1)

      fill_in "Discount quantity", with: 100
      fill_in "Discount amount", with: ""
      click_button "Update Discount"

      expect(page).to have_content("Discount amount can't be blank")
      expect(page).to have_content("Discount amount is not a number")
      expect(page).to have_content("Edit Discount")
    end
  end


end
