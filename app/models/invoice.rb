class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :items

  enum status: [:cancelled, 'in progress', :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_discount
    InvoiceItem.joins(:bulk_discounts)
    .where("invoice_items.quantity >= bulk_discounts.minimum_quantity")
    .select("invoice_items.id, max(invoice_items.quantity * invoice_items.unit_price * (bulk_discounts.percent_off / 100.00)) AS best_disc")
    .group("invoice_items.id")
    .order(best_disc: :desc)
    .sum(&:best_disc)
  end

  def total_revenue_after_discounts
   total_revenue - total_discount
  end
end
