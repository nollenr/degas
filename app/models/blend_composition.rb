class BlendComposition < ActiveRecord::Base
  attr_accessible :blend_id, :grape_id, :percent_of_grape
  
  belongs_to :blend
end
