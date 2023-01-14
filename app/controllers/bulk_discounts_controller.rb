class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @merchant.bulk_discounts.new
  end
  
  def create
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = merchant.bulk_discounts.new(bulk_discount_params)
    if bulk_discount.save 
      redirect_to "/merchant/#{merchant.id}/bulk_discounts"
      flash[:alert] = "Bulk Discount added"
    else
      redirect_to "/merchant/#{merchant.id}/bulk_discounts/new"
      flash[:alert] = "Error: All fields are required."
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    discount = BulkDiscount.find_by(merchant_id: params[:merchant_id], id: params[:id])
    discount.destroy
    redirect_to merchant_bulk_discounts_path(merchant)
  end

  def show
    @show_discount = BulkDiscount.find(params[:id])
    # require 'pry'; binding.pry
  end

  private

  def bulk_discount_params
    params.permit(:name, :percent_off, :minimum_quantity)
  end
end
