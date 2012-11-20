class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, primary_key_trigger: true do |t|
      t.string :username, null: false
      t.string :email, null: false

      t.timestamps
    end
    add_index :users, :username, unique: true
  end
end

