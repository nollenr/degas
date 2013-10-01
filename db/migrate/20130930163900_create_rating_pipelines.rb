class CreateRatingPipelines < ActiveRecord::Migration
  def change
    create_table :rating_pipelines do |t|
      t.timestamp :tasting_date
      t.string :tasting_notes
      t.integer :rating

      t.timestamps
    end
  end
end
