# == Schema Information
#
# Table name: wineries
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  country      :string(255)      not null
#  location1    :string(255)      not null
#  location2    :string(255)
#  location3    :string(255)
#  facebook_url :string(255)
#  twitter_url  :string(255)
#  winery_url   :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Winery < ActiveRecord::Base
  has_many :bottles
  attr_accessible :country, :facebook_url, :location1, :location2, :location3, :name, :twitter_url, :winery_url

  validates :name, presence: true, uniqueness: true
  validates :country, presence: true
  validates :location1, presence: true
  validates :location2, presence: true
end
