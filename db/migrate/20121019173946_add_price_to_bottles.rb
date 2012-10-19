class AddPriceToBottles < ActiveRecord::Migration
  def change
   add_column :bottles, :price, :float, precision: 8, scale: 2
  end
end
