class BottleAvailability < ActiveRecord::Migration
  def up
    add_column :bottles, :available, :boolean
  end

  def down
    remove_column :bottles, :available
  end
end
