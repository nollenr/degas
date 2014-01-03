class CreateBlends < ActiveRecord::Migration
  def change
    create_table :blends do |t|
      t.string :name, limit: 50

      t.timestamps
    end
  add_index :blends, [:name], unique: true
  end
end
