class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find_by(params[:id])
    @bulk_discounts = @merchant.bulk_discounts
  end

   
end