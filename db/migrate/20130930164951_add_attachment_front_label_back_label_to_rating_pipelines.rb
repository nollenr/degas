class AddAttachmentFrontLabelBackLabelToRatingPipelines < ActiveRecord::Migration
  def self.up
    change_table :rating_pipelines do |t|
      t.attachment :front_label
      t.attachment :back_label
    end
  end

  def self.down
    drop_attached_file :rating_pipelines, :front_label
    drop_attached_file :rating_pipelines, :back_label
  end
end
