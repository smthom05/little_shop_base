require 'rails_helper'

RSpec.describe 'merchant can add a new discount', type: :feature do
  before :each do
    @merchant = create(:merchant)
  end

  describe 'merchant has clicked add discount link and arrived on the form for adding discount' do
    it 'can fill out the form and create the discount' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

    visit new_dashboard_discount_path

    expect(page).to have_field("Discount amount")
    expect(page).to have_field("Discount quantity")
    expect(page).to have_button("Create Discount")

    fill_in "Discount amount", with: 100
    fill_in "Discount quantity", with: 75

    click_button ("Create Discount")

    expect(page).to have_content("Your Current Discounts")
    expect(page).to have_content("New Discount Added!")

    new_discount = Discount.last

    within "#discount-#{new_discount.id}"
      expect(page).to have_content("Discount Number: #{new_discount.id}")
      expect(page).to have_content("Discounted Amount: #{new_discount.discount_amount}")
      expect(page).to have_content("Required Spending: #{new_discount.discount_quantity}")
    end
  end

  it 'cannot submit the discount with missing amount' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

    visit new_dashboard_discount_path

    fill_in "Discount quantity", with: 100
    click_button "Create Discount"

    expect(page).to have_content("Discount amount can't be blank")
    expect(page).to have_content("Discount amount is not a number")
    expect(page).to have_content("Add A New Discount")
  end

  it 'cannot submit the discount with missing quantity' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

    visit new_dashboard_discount_path

    fill_in "Discount amount", with: 100
    click_button "Create Discount"

    expect(page).to have_content("Discount quantity can't be blank")
    expect(page).to have_content("Discount quantity is not a number")
    expect(page).to have_content("Add A New Discount")
  end
end
