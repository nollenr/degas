class Grape < ActiveRecord::Base
  has_many :bottles
  attr_accessible :color, :name
end
