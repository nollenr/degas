class Winery < ActiveRecord::Base
  has_many :bottles
  attr_accessible :country, :facebook_url, :location1, :location2, :location3, :name, :twitter_url, :winery_url
end
