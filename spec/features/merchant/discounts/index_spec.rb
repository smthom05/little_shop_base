require 'rails_helper'

RSpec.describe 'merchant discounts index' do
  before :each do
    @merchant = create(:merchant)
    @merchant_2 = create(:merchant)
    @discount_1 = @merchant.discounts.create(discount_amount: 10, discount_quantity: 50)
    @discount_2 = @merchant.discounts.create(discount_amount: 20, discount_quantity: 100)
  end

  describe 'merchant user visits their profile' do
    it 'sees a link to manage their discounts that takes you to the discount index' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      visit dashboard_path

      expect(page).to have_link("Manage Bulk Discounts")

      click_link("Manage Bulk Discounts")

      expect(page).to have_content("Your Current Discounts")
    end
  end

  describe 'once on their discounts index page' do
    it 'tells them they do not have any discounts if they have not created any yet' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_2)
      visit dashboard_discounts_path

      expect(page).to have_content("You have not added any discounts yet.")

    end

    it 'shows them all of their discounts if have discounts' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      discount_3 = @merchant_2.discounts.create(discount_amount: 5, discount_quantity: 25)

      visit dashboard_discounts_path

      within "#discount-#{@discount_1.id}" do
        expect(page).to have_content("Discount Number: #{@discount_1.id}")
        expect(page).to have_content("Discounted Amount: #{@discount_1.discount_amount}")
        expect(page).to have_content("Required Spending: #{@discount_1.discount_quantity}")
      end

      within "#discount-#{@discount_2.id}" do
        expect(page).to have_content("Discount Number: #{@discount_2.id}")
        expect(page).to have_content("Discounted Amount: #{@discount_2.discount_amount}")
        expect(page).to have_content("Required Spending: #{@discount_2.discount_quantity}")
      end

      expect(page).to_not have_content("Discount Number: #{discount_3.id}")
      expect(page).to_not have_content("Discounted Amount: #{discount_3.discount_amount}")
      expect(page).to_not have_content("Required Spending: #{discount_3.discount_quantity}")
    end

    it 'shows a link for the merchant to add a new discount that brings them to the new discount page' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit dashboard_discounts_path

      expect(page).to have_link("Add Discount")

      click_link "Add Discount"

      expect(current_path).to eq(new_dashboard_discount_path)
      expect(page).to have_content("Add A New Discount")
    end

    it 'can click on the discount number and go to a discount show page' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

      visit dashboard_discounts_path

      expect(page).to have_link(@discount_1.id)

      click_link @discount_1.id

      expect(current_path).to eq(dashboard_discount_path(@discount_1))
    end
  end
end
