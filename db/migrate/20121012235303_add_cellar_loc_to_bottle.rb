class AddCellarLocToBottle < ActiveRecord::Migration
  def change
    add_column :bottles, :cellar_location, :string, limit: 30
  end
end
