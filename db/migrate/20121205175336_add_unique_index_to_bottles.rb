class AddUniqueIndexToBottles < ActiveRecord::Migration
  def change
    add_index :bottles, [:user_id, :bottle_id], unique: true
  end
end
