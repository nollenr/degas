class Bottle < ActiveRecord::Base
  belongs_to :grape
  attr_accessible :bottle_id
end
