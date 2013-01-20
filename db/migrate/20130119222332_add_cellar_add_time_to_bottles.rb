class AddCellarAddTimeToBottles < ActiveRecord::Migration
  def change
    add_column :bottles, :date_added_to_cellar, :datetime
    add_column :bottles, :notes, :text
  end
end
