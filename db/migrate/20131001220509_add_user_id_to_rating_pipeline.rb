class AddUserIdToRatingPipeline < ActiveRecord::Migration

  def change
    add_column :rating_pipelines, :user_id, :integer, null: false
  end

end
