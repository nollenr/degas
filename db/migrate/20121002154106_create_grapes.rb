class CreateGrapes < ActiveRecord::Migration
  def change
    create_table :grapes, primary_key_trigger: true do |t|
      t.string :name, limit: 100, null: false
      t.string :color, limit: 10, null: false
      t.text   :description, null: true

      t.timestamps
    end
  end
end
