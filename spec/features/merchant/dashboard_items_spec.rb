require 'rails_helper'

include ActionView::Helpers::NumberHelper

RSpec.describe 'Merchant Dashboard Items page' do
  before :each do
    @merchant = create(:merchant)
    @admin = create(:admin)

    @items = create_list(:item, 3, user: @merchant)
    @items << create(:inactive_item, user: @merchant)

    @order = create(:completed_order)
    @oi_1 = create(:fulfilled_order_item, order: @order, item: @items[0], price: 1, quantity: 1, created_at: 2.hours.ago, updated_at: 50.minutes.ago)
  end

  describe 'should allow me to add a new item' do
    describe 'with their image if one is provided' do
      scenario 'when logged in as merchant' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
        @am_admin = false
        visit dashboard_items_path
      end
      scenario 'when logged in as admin' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
        @am_admin = true
        visit admin_merchant_items_path(@merchant.slug)
      end
      after :each do
        click_link('Add new Item')

        if @am_admin
          expect(current_path).to eq(new_admin_merchant_item_path(@merchant.slug))
        else
          expect(current_path).to eq(new_dashboard_item_path)
        end
        placeholder_image = 'https://picsum.photos/200/300/?image=524'
        image = 'https://picsum.photos/200/300/?image=5'

        name = 'Item Name 1'
        description = 'Item Description 1'
        price = 9999.99
        inventory = 10000

        fill_in :item_name, with: name
        fill_in :item_description, with: description
        fill_in :item_image, with: image
        fill_in :item_price, with: price
        fill_in :item_inventory, with: inventory
        click_button 'Create Item'

        if @am_admin
          expect(current_path).to eq(admin_merchant_items_path(@merchant.slug))
        else
          expect(current_path).to eq(dashboard_items_path)
        end
        expect(page).to have_content("#{name} has been added!")
        item = Item.last

        within "#item-#{item.id}" do
          expect(page).to have_content("ID: #{item.id}")
          expect(page).to have_content("Name: #{name}")
          expect(page.find("#item-#{item.id}-image")['src']).to_not have_content(placeholder_image)
          expect(page.find("#item-#{item.id}-image")['src']).to have_content(image)
          expect(page).to have_content("Price: #{number_to_currency(price)}")
          expect(page).to have_content("Inventory: #{inventory}")
          expect(page).to have_link('Edit Item')
          expect(page).to have_button('Delete Item')
          expect(page).to have_button('Disable Item')
          click_link item.name
        end
        expect(page).to have_content(description)
      end
    end

    describe 'with a default image if none is provided' do
      scenario 'when logged in as merchant' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
        @am_admin = false
        visit dashboard_items_path
      end
      scenario 'when logged in as admin do' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
        @am_admin = true
        visit admin_merchant_items_path(@merchant.slug)
      end
      after :each do
        click_link('Add new Item')
        if @am_admin
          expect(current_path).to eq(new_admin_merchant_item_path(@merchant.slug))
        else
          expect(current_path).to eq(new_dashboard_item_path)
        end
        placeholder_image = 'https://picsum.photos/200/300/?image=524'

        name = 'Item Name 1'
        description = 'Item Description 1'
        price = 9999.99
        inventory = 10000

        fill_in :item_name, with: name
        fill_in :item_description, with: description
        # fill_in :image, with: ""
        fill_in :item_price, with: price
        fill_in :item_inventory, with: inventory
        click_button 'Create Item'

        if @am_admin
          expect(current_path).to eq(admin_merchant_items_path(@merchant.slug))
        else
          expect(current_path).to eq(dashboard_items_path)
        end
        expect(page).to have_content("#{name} has been added!")
        item = Item.last

        within "#item-#{item.id}" do
          expect(page).to have_content("ID: #{item.id}")
          expect(page).to have_content("Name: #{name}")
          expect(page.find("#item-#{item.id}-image")['src']).to have_content(placeholder_image)
          expect(page).to have_content("Price: #{number_to_currency(price)}")
          expect(page).to have_content("Inventory: #{inventory}")
          expect(page).to have_link('Edit Item')
          expect(page).to have_button('Delete Item')
          expect(page).to have_button('Disable Item')
          click_link item.name
        end
        expect(page).to have_content(description)
      end
    end

    describe 'does not work if required fields are left empty' do
      scenario 'as a merchant' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
        visit new_dashboard_item_path
      end
      scenario 'as an admin' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
        visit new_admin_merchant_item_path(@merchant.slug)
      end
      after :each do
        click_button 'Create Item'

        expect(page).to have_content('6 errors prohibited this item from being saved')
        expect(page).to have_content("Name can't be blank")
        expect(page).to have_content("Description can't be blank")
        expect(page).to have_content("Price can't be blank")
        expect(page).to have_content("Price is not a number")
        expect(page).to have_content("Inventory can't be blank")
        expect(page).to have_content("Inventory is not a number")
      end
    end
  end

  describe 'should show all items and link to add more items' do
    scenario 'when logged in as merchant' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      @am_admin = false
      visit dashboard_path
    end
    scenario 'when logged in as admin' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      @am_admin = true
      visit admin_merchant_path(@merchant.slug)
    end
    after :each do
      click_link 'Items for Sale'
      if @am_admin
        expect(current_path).to eq(admin_merchant_items_path(@merchant.slug))
      else
        expect(current_path).to eq(dashboard_items_path)
      end

      expect(page).to have_link('Add new Item')

      @items.each_with_index do |item, index|
        within "#item-#{item.id}" do
          expect(page).to have_content("ID: #{item.id}")
          expect(page).to have_content("Name: #{item.name}")
          expect(page.find("#item-#{item.id}-image")['src']).to have_content(item.image)
          expect(page).to have_content("Price: #{number_to_currency(item.price)}")
          expect(page).to have_content("Inventory: #{item.inventory}")
          expect(page).to have_link('Edit Item')

          if index == 0
            expect(page).to_not have_button('Delete Item')
          else
            expect(page).to have_button('Delete Item')
          end
          if index != 3
            expect(page).to have_button('Disable Item')
            expect(page).to_not have_button('Enable Item')
          else
            expect(page).to have_button('Enable Item')
            expect(page).to_not have_button('Disable Item')
          end
        end
      end
    end
  end

  describe 'allows me to disable then re-enable an active item' do
    before :each do
      @item = create(:item, user: @merchant, name: 'Widget', description: 'Something witty goes here', price: 1.23, inventory: 456)
    end
    scenario 'when logged in as merchant' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
      @am_admin = false
      visit dashboard_items_path
    end
    scenario 'when logged in as admin' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      @am_admin = true
      visit admin_merchant_items_path(@merchant.slug)
    end
    after :each do
      within "#item-#{@item.id}" do
        click_button 'Disable Item'
      end

      if @am_admin
        expect(current_path).to eq(admin_merchant_items_path(@merchant.slug))
      else
        expect(current_path).to eq(dashboard_items_path)
      end

      within "#item-#{@item.id}" do
        expect(page).to_not have_button('Disable Item')
        click_button 'Enable Item'
      end

      if @am_admin
        expect(current_path).to eq(admin_merchant_items_path(@merchant.slug))
      else
        expect(current_path).to eq(dashboard_items_path)
      end

      within "#item-#{@items[0].id}" do
        expect(page).to_not have_button('Enable Item')
      end
    end
  end

  describe 'when trying to delete an item' do
    describe 'works when nobody has purchased that item before' do
      scenario 'when logged in as merchant' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
        @am_admin = false
        visit dashboard_items_path
      end
      scenario 'when logged in as admin' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
        @am_admin = true
        visit admin_merchant_items_path(@merchant.slug)
      end
      after :each do
        within "#item-#{@items[1].id}" do
          click_button 'Delete Item'
        end

        if @am_admin
          expect(current_path).to eq(admin_merchant_items_path(@merchant.slug))
        else
          expect(current_path).to eq(dashboard_items_path)
        end
        expect(page).to_not have_css("#item-#{@items[1].id}")
        expect(page).to_not have_content(@items[1].name)
      end
    end

    describe 'fails if someone has purchased that item before' do
      scenario 'when logged in as merchant' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
        @am_admin = false
        visit dashboard_items_path
      end
      scenario 'when logged in as admin' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
        @am_admin = true
        visit admin_merchant_items_path(@merchant.slug)
      end
      after :each do
        page.driver.delete(dashboard_item_path(@items[0]))
        expect(page.status_code).to eq(302)
        if @am_admin
          visit admin_merchant_items_path(@merchant.slug)
        else
          visit dashboard_items_path
        end
        expect(page).to have_css("#item-#{@items[0].id}")
        expect(page).to have_content("Attempt to delete #{@items[0].name} was thwarted!")
      end
    end
  end

  describe 'when editing an existing item' do
    describe 'should work if I enter valid details' do
      before :each do
        @item = create(:item, user: @merchant, name: 'Widget', description: 'Something witty goes here', price: 1.23, inventory: 456)
      end
      scenario 'when logged in as merchant' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
        @am_admin = false
        visit dashboard_items_path
      end
      scenario 'when logged in as admin' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
        @am_admin = true
        visit admin_merchant_items_path(@merchant.slug)
      end
      after :each do
        within "#item-#{@item.id}" do
          click_link 'Edit Item'
        end
        if @am_admin
          expect(current_path).to eq(edit_admin_merchant_item_path(@merchant.slug, @item.slug))
        else
          expect(current_path).to eq(edit_dashboard_item_path(@item.slug))
        end

        fill_in :item_name, with: 'New ' + @item.name
        fill_in :item_description, with: 'New ' + @item.description
        fill_in :item_price, with: 7654.32
        fill_in :item_inventory, with: 987
        click_button 'Update Item'

        if @am_admin
          expect(current_path).to eq(admin_merchant_items_path(@merchant.slug))
        else
          expect(current_path).to eq(dashboard_items_path)
        end
        expect(page).to have_content("New #{@item.name} has been updated!")

        within "#item-#{@item.id}" do
          expect(page).to have_content("Name: New #{@item.name}")
          expect(page).to have_content("Price: #{number_to_currency(7654.32)}")
          expect(page).to have_content("Inventory: 987")
          click_link "New #{@item.name}"
        end
        expect(page).to have_content('New ' + @item.description)
      end
    end

    describe 'should replace a blank image field with the placeholder' do
      before :each do
        @item = create(:item, user: @merchant, name: 'Widget', description: 'Something witty goes here', price: 1.23, inventory: 456)
      end
      scenario 'when logged in as merchant' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
        @am_admin = false
        visit edit_dashboard_item_path(@item.slug)
      end
      scenario 'when logged in as admin' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
        @am_admin = true
        visit edit_admin_merchant_item_path(@merchant.slug, @item.slug)
      end
      after :each do
        placeholder_image = 'https://picsum.photos/200/300/?image=524'
        image = 'https://picsum.photos/200/300/?image=5'

        fill_in :item_image, with: ""
        click_button 'Update Item'

        within "#item-#{@item.id}" do
          expect(page.find("#item-#{@item.id}-image")['src']).to have_content(placeholder_image)
          expect(page.find("#item-#{@item.id}-image")['src']).to_not have_content(@item.image)
        end
      end
    end

    describe 'should block the update if details are missing' do
      before :each do
        @item = create(:item, user: @merchant, name: 'Widget', description: 'Something witty goes here', price: 1.23, inventory: 456)
      end
      scenario 'when logged in as merchant' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
        @am_admin = false
        visit edit_dashboard_item_path(@item.slug)
      end
      scenario 'when logged in as admin' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
        @am_admin = true
        visit edit_admin_merchant_item_path(@merchant.slug, @item.slug)
      end
      after :each do
        fill_in :item_name, with: ""
        fill_in :item_description, with: ""
        fill_in :item_price, with: ""
        fill_in :item_inventory, with: ""
        click_button 'Update Item'

        expect(page).to have_content("prohibited this item from being saved")
        expect(page).to have_content("Name can't be blank")
        expect(page).to have_content("Description can't be blank")
        expect(page).to have_content("Price can't be blank")
        expect(page).to have_content("Price is not a number")
        expect(page).to have_content("Inventory can't be blank")
        expect(page).to have_content("Inventory is not a number")
      end
    end
  end
end
