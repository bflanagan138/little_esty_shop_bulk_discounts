require 'httparty'
require 'json'

class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts

    response = HTTParty.get 'https://date.nager.at/api/v3/NextPublicHolidays/US' 
    api_body = response.body 
    @holidays = JSON.parse(api_body, symbolize_names: true).first(3)
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
  end

  def edit
    @edit_discount = BulkDiscount.find(params[:id])
  end

  def update
    discount = BulkDiscount.find_by(merchant_id: params[:merchant_id], id: params[:id])
    discount.update(bulk_discount_params)
# require 'pry'; binding.pry
    redirect_to "/merchant/#{discount.merchant_id}/bulk_discounts/#{discount.id}"
    flash[:alert] = "Discount Updated"
  end

  private

  def bulk_discount_params
    params.permit(:name, :percent_off, :minimum_quantity)
  end
end
