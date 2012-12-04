class AddUserIdToBottles < ActiveRecord::Migration
  def change
    add_column :bottles, :user_id, :integer, null: false
  end
end
