class CreateBottles < ActiveRecord::Migration
  def change
    create_table :bottles, primary_key_trigger: true do |t|
      t.integer :bottle_id
      t.belongs_to :grape

      t.timestamps
    end
    add_index :bottles, :grape_id
  end
end
