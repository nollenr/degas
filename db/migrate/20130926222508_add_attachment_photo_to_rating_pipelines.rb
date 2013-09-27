class AddAttachmentPhotoToRatingPipelines < ActiveRecord::Migration
  def self.up
    change_table :rating_pipelines do |t|
      t.attachment :photo
    end
  end

  def self.down
    drop_attached_file :rating_pipelines, :photo
  end
end
