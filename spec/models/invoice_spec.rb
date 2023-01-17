require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
    it { should have_many(:bulk_discounts).through(:items)}
  end
  describe "instance methods" do
    it "total_revenue" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)

      expect(@invoice_1.total_revenue).to eq(100)
    end

    it "discounts" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 7, unit_price: 10, status: 1)
      @ii_111 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 9, unit_price: 10, status: 1)

      @bulk_discounts_1 = @merchant1.bulk_discounts.create!(name: "Ten for Ten", minimum_quantity: 10, percent_off: 10)
      @bulk_discounts_2 = @merchant1.bulk_discounts.create!(name: "Eight for Eight", minimum_quantity: 8, percent_off: 8)
      @bulk_discounts_3 = @merchant1.bulk_discounts.create!(name: "Five for 6", minimum_quantity: 6, percent_off: 5)

      expect(@invoice_1.total_revenue).to eq(260.0)

    end
    before(:each) do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 7, unit_price: 10, status: 1)
      @ii_111 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 9, unit_price: 10, status: 1)

      @bulk_discounts_1 = @merchant1.bulk_discounts.create!(name: "Ten for Ten", minimum_quantity: 10, percent_off: 10)
      @bulk_discounts_2 = @merchant1.bulk_discounts.create!(name: "Eight for Eighty", minimum_quantity: 80, percent_off: 8)
      @bulk_discounts_3 = @merchant1.bulk_discounts.create!(name: "Five for 6", minimum_quantity: 6, percent_off: 5)
    end

    # it "displays total discounted revenue" do
    #   expect(@invoice_1.total_discounted_revenue).to eq(100)
    # end

    it "has available discounts ordered from largest to smallest by quantity" do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 7, unit_price: 10, status: 1)
      @ii_111 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 9, unit_price: 10, status: 1)

      @bulk_discounts_1 = @merchant1.bulk_discounts.create!(name: "Ten for Ten", minimum_quantity: 10, percent_off: 10)
      @bulk_discounts_2 = @merchant1.bulk_discounts.create!(name: "Eight for Eighty", minimum_quantity: 80, percent_off: 8)
      @bulk_discounts_3 = @merchant1.bulk_discounts.create!(name: "Five for 6", minimum_quantity: 6, percent_off: 5)
   
      expect(@invoice_1.bulk_discount_options).to eq([@bulk_discounts_2, @bulk_discounts_1, @bulk_discounts_3])
    end
  end
end
