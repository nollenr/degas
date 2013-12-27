class CreateBlendCompositions < ActiveRecord::Migration
  def change
    create_table :blend_compositions do |t|
      t.integer :percent_of_grape
      t.integer :blend_id, null: false
      t.integer :grape_id, null: false

      t.timestamps
    end
  add_index :blend_compositions, [:blend_id, :grape_id], unique: true
  end
end
