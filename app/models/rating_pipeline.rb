class RatingPipeline < ActiveRecord::Base
  attr_accessible :rating_date, :rating_place, :photo
  
  has_attached_file :photo, :styles => { :small => "150x150>"}
end
