class BulkDiscount < ApplicationRecord
  validates_presence_of :name, :minimum_quantity, :percent_off
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoices, through: :items


end
