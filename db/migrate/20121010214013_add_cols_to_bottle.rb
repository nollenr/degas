class AddColsToBottle < ActiveRecord::Migration
  def change
    add_column :bottles, :vintage, :string, limit: 4
    add_column :bottles, :drink_by_year, :string, limit: 4
    add_column :bottles, :vineyard, :string
    add_column :bottles, :name, :string
  end
end
