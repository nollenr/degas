class Winery < ActiveRecord::Base
  attr_accessible :country, :facebook_url, :location1, :location2, :location3, :name, :twitter_url, :winery_url
end
