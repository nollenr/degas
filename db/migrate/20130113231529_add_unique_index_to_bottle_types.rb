class AddUniqueIndexToBottleTypes < ActiveRecord::Migration
  def change
    add_index :bottle_types, [:name], unique: true
  end
end
