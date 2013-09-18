class AddBuyAgainFeatureToBottle < ActiveRecord::Migration
  def change
    add_column :bottles, :buy_at_this_price, :boolean
  end
end
