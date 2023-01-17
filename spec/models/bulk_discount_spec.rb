require 'rails_helper'

RSpec.describe BulkDiscount do 
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many(:items).through(:merchant) }
    it { should have_many(:invoices).through(:items) }

  end
end