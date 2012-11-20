class AddLimitToUser < ActiveRecord::Migration
  def change
    change_column :users, :username, :string, limit: 35
  end
end
