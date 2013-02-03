class AddIndexToWinery < ActiveRecord::Migration
  def change
    add_index :wineries, [:name], unique: true
  end
end
