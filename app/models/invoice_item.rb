class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item
  has_many :transactions, through: :invoice
  has_one :merchant, through: :item
  has_one :customer, through: :invoice
  has_many :bulk_discounts, through: :item
  
  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end


  def item_bulk_discount
    self.bulk_discounts
    .where("bulk_discounts.minimum_quantity <= #{self.quantity}")
    .order("bulk_discounts.percent_off desc").first
    # .limit(1)
    end
end
