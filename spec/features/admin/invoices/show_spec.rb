require 'rails_helper'

  describe 'Admin Invoices Index Page' do
    before :each do
      @m1 = Merchant.create!(name: 'Merchant 1')

      @c1 = Customer.create!(first_name: 'Yo', last_name: 'Yoz', address: '123 Heyyo', city: 'Whoville', state: 'CO', zip: 12345)
      @c2 = Customer.create!(first_name: 'Hey', last_name: 'Heyz')

      @i1 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: '2012-03-25 09:54:09')
      @i2 = Invoice.create!(customer_id: @c2.id, status: 1, created_at: '2012-03-25 09:30:09')

      @item_1 = Item.create!(name: 'test', description: 'lalala', unit_price: 6, merchant_id: @m1.id)
      @item_2 = Item.create!(name: 'rest', description: 'dont test me', unit_price: 12, merchant_id: @m1.id)

      @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 12, unit_price: 6, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 6, unit_price: 12, status: 1)
      @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_2.id, quantity: 87, unit_price: 22, status: 2)

      visit admin_invoice_path(@i1)
    end

    it 'should display the id, status and created_at' do
      expect(page).to have_content("Invoice ##{@i1.id}")
      expect(page).to have_content("Created on: #{@i1.created_at.strftime("%A, %B %d, %Y")}")

      expect(page).to_not have_content("Invoice ##{@i2.id}")
    end

    it 'should display the customers name and shipping address' do
      expect(page).to have_content("#{@c1.first_name} #{@c1.last_name}")
      expect(page).to have_content(@c1.address)
      expect(page).to have_content("#{@c1.city}, #{@c1.state} #{@c1.zip}")

      expect(page).to_not have_content("#{@c2.first_name} #{@c2.last_name}")
    end

    it 'should display all the items on the invoice' do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_2.name)

      expect(page).to have_content(@ii_1.quantity)
      expect(page).to have_content(@ii_2.quantity)

      expect(page).to have_content("$#{@ii_1.unit_price}")
      expect(page).to have_content("$#{@ii_2.unit_price}")

      expect(page).to have_content(@ii_1.status)
      expect(page).to have_content(@ii_2.status)

      expect(page).to_not have_content(@ii_3.quantity)
      expect(page).to_not have_content("$#{@ii_3.unit_price}")
      expect(page).to_not have_content(@ii_3.status)
    end

    it 'should display the total revenue the invoice will generate' do
      expect(page).to have_content("Total Revenue: $#{@i1.total_revenue}")

      expect(page).to_not have_content(@i2.total_revenue)
    end

    it 'should have status as a select field that updates the invoices status' do
      within("#status-update-#{@i1.id}") do
        select('cancelled', :from => 'invoice[status]')
        expect(page).to have_button('Update Invoice')
        click_button 'Update Invoice'

        expect(current_path).to eq(admin_invoice_path(@i1))
        expect(@i1.status).to eq('completed')
      end
    end
  end

  describe 'US8' do 
    before(:each) do
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
      visit admin_invoice_path(@invoice_1)
    end

    it 'shows total revenue after bulk discounts are applied' do
      expect(page).to have_content("Total Discounted Revenue: $#{@invoice_1.total_revenue_after_discounts}")
    end
end
