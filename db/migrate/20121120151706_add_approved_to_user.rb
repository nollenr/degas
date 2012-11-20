class AddApprovedToUser < ActiveRecord::Migration
  def change
    add_column :users, :approved_user, :boolean, null: false, default: false
  end
end
