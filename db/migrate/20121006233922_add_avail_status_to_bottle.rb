class AddAvailStatusToBottle < ActiveRecord::Migration
  def change
    add_column :bottles, :availability_change_date, :timestamp
    add_column :bottles, :availability_change_message, :string
  end
end
