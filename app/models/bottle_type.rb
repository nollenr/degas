class BottleType < ActiveRecord::Base
  has_many :bottles
  attr_accessible :name
end
