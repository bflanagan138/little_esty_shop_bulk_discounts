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
    # require 'pry'; binding.pry
    bulk_discount = merchant.bulk_discounts.create!(bulk_discount_params)
    redirect_to "/merchant/#{bulk_discount_params(:merchant_id)}/bulk_discounts"
    # if bulk_discount.save 
    #   redirect_to "/merchant/#{bulk_discount_params(:merchant_id)}/bulk_discounts"
    #   flash[:alert] = "Bulk Discount added"
    # else
    #   redirect_to "/merchant/#{merchant.id}/bulk_discounts/new"
    #   flash[:alert] = "Error: All fields are required."
    # end

  end

  private

  def bulk_discount_params
    params.permit(:name, :percent_off, :minimum_quantity)
  end
end