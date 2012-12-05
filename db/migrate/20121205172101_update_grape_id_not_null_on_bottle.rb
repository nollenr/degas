class UpdateGrapeIdNotNullOnBottle < ActiveRecord::Migration
  def up
    change_column :bottles, :grape_id, :integer, null: false
  end

  def down
    change_column :bottles, :grape_id, :integer, null: true 
  end
end
