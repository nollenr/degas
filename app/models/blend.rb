class Blend < ActiveRecord::Base
  attr_accessible :name
  
  has_many :blend_compositions
  has_many :grapes, through: :blend_compositions
end
