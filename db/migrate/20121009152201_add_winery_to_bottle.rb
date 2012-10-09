class AddWineryToBottle < ActiveRecord::Migration
  def change
    add_column :bottles, :winery_id, :integer
  end
end
