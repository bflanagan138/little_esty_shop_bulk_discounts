require 'rails_helper'

RSpec.describe 'merchant dashboard' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')
    @merchant2 = Merchant.create!(name: 'Nail Salon')

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_5 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)
    @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    @bulk_discounts_1 = BulkDiscount.create!(name: "Ten for Ten", minimum_quantity: 10, percent_off: 10, merchant_id: @merchant1.id)
    @bulk_discounts_2 = BulkDiscount.create!(name: "Tuesday Special", minimum_quantity: 15, percent_off: 12, merchant_id: @merchant1.id)
    @bulk_discounts_3 = BulkDiscount.create!(name: "Half Price", minimum_quantity: 100, percent_off: 50, merchant_id: @merchant1.id)
    @bulk_discounts_4 = BulkDiscount.create!(name: "Stingy Offer", minimum_quantity: 44, percent_off: 5, merchant_id: @merchant2.id)

    visit merchant_bulk_discounts_path(@merchant1)
  end

  describe 'bd_us1' do
    it 'shows all bulk discounts including their percentage discounts and quantity thresholds' do
      visit merchant_bulk_discounts_path(@merchant1)
     
      expect(page).to have_content(@bulk_discounts_1.name)
      expect(page).to have_content(@bulk_discounts_1.percent_off)
      expect(page).to have_content(@bulk_discounts_1.minimum_quantity)
      expect(page).to_not have_content(@bulk_discounts_4.name)
    end
  end
end

#   describe 'bd_us2' do
#     it 'shows a link to create a new discount and when I click that link it takes me to a new discount page' do
#       visit merchant_bulk_discounts_path(@merchant1)

#       expect(page).to have_link("New Discount")
#       click_link("New Discount")

#       expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts/new")
#     end

#     it 'has a form to create a new discount' do
#       visit new_merchant_bulk_discount_path(@merchant1)

#       expect(page).to have_content("Create a New Discount")
#       expect(page).to have_field("Discount Name:")
#       expect(page).to have_field("Percent Off:")
#       expect(page).to have_field("Minimum Item Purchase Quantity:")
#       fill_in("Discount Name:", with: "Saturday Scramble")
#       fill_in("Percent Off:", with: "10")
#       fill_in("Minimum Item Purchase Quantity:", with: "8")
#       click_button("Save ")
#       expect(current_path).to eq("/merchant/#{@merchant1.id}/bulk_discounts")
#       # expect(page).to have_content("Saturday Scramble")
#       save_and_open_page
#     end
#   end
# end
