class CreateBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.string :name
      t.integer :percent_off
      t.integer :minimum_quantity
      t.references :merchant, foreign_key: true
      t.timestamps
    end
  end
end
