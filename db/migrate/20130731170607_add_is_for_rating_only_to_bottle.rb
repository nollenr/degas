class AddIsForRatingOnlyToBottle < ActiveRecord::Migration
  def change
    add_column :bottles, :is_for_rating_only, :boolean, default: false
    Bottle.update_all({is_for_rating_only: false})
    change_column :bottles, :is_for_rating_only, :boolean, null: false
  end
end
