class AddRatingToBottles < ActiveRecord::Migration
  def change
    add_column :bottles, :rating, :integer
  end
end
