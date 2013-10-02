class AddPriceToRatingPipeline < ActiveRecord::Migration
  def change
    add_column :rating_pipelines, :price, :decimal, precision: 8, scale: 2 
  end
end
