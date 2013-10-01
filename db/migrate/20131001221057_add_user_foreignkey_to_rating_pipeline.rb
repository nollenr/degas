class AddUserForeignkeyToRatingPipeline < ActiveRecord::Migration

  def up
    execute 'ALTER TABLE rating_pipelines ADD CONSTRAINT rating_pipelines_fk_001 FOREIGN KEY (user_id) REFERENCES users(id)'
  end

  def down
    execute 'ALTER TABLE bottles DROP CONSTRAINT rating_pipelines_fk_001'
  end

end
