class AddPriceToBottles < ActiveRecord::Migration
  def change
   add_column :bottles, :price, :decimal, precision: 8, scale: 2
  end
end
