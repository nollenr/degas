class CreateRatingPipelines < ActiveRecord::Migration
  def change
    create_table :rating_pipelines do |t|
      t.timestamp :rating_date
      t.string :rating_place

      t.timestamps
    end
  end
end
