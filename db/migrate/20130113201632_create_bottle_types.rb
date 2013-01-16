class CreateBottleTypes < ActiveRecord::Migration
  def change
    create_table :bottle_types do |t|
      t.string :name, limit: 30, null: false 

      t.timestamps
    end
  end
end
