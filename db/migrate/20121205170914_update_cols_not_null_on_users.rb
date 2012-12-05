class UpdateColsNotNullOnUsers < ActiveRecord::Migration
  def up
    change_column :users, :password_digest, :string, null: false
    change_column :users, :remember_token, :string, null: false
  end

  def down
    change_column :users, :password_digest, :string, null: true
    change_column :users, :remember_token, :string, null: true
  end
end
