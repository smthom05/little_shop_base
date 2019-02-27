require 'rails_helper'

RSpec.describe "Discount Show Page", type: :feature do
  before :each do
    @merchant = create(:merchant)
    @discount_1 = @merchant.discounts.create(discount_amount: 10, discount_quantity: 50)
    @discount_2 = @merchant.discounts.create(discount_amount: 33, discount_quantity: 5550)

  end
  describe 'once a merchant lands on a discount show page' do
    it 'shows them the information about the specific discount' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit dashboard_discount_path(@discount_1)

      within '.card' do
        expect(page).to have_content("Discount Number: #{@discount_1.id}")
        expect(page).to have_content("Discounted Amount: #{@discount_1.discount_amount}")
        expect(page).to have_content("Required Spending: #{@discount_1.discount_quantity}")
      end
    end

    it 'shows them a button to edit the discount that takes me to an edit form' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit dashboard_discount_path(@discount_1)

      within '.card' do
        expect(page).to have_button("Edit Discount")
      end

      click_button "Edit Discount"

      expect(current_path).to eq(edit_dashboard_discount_path(@discount_1))
      expect(page).to have_field("Discount amount")
      expect(page).to have_field("Discount quantity")
      expect(page).to have_button("Update Discount")
    end

    it 'shows them a button to delete the discount that takes us back to the discount index' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit dashboard_discount_path(@discount_1)

      within '.card' do
        expect(page).to have_button("Delete Discount")
      end

      click_button "Delete Discount"

      expect(current_path).to eq(dashboard_discounts_path)

      expect(page).to have_content("Successfully Deleted Discount Number: #{@discount_1.id}!")

      within '.all-discounts' do
        expect(page).to_not have_content("Discount Number: #{@discount_1.id}")
        expect(page).to_not have_content("Discounted Amount: #{@discount_1.discount_amount}")
        expect(page).to_not have_content("Required Spending: #{@discount_1.discount_quantity}")

        expect(page).to have_content("Discount Number: #{@discount_2.id}")
        expect(page).to have_content("Discounted Amount: #{@discount_2.discount_amount}")
        expect(page).to have_content("Required Spending: #{@discount_2.discount_quantity}")
      end
    end
  end
end