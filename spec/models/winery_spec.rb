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

require 'spec_helper'

describe Winery do
  pending "add some examples to (or delete) #{__FILE__}"
end
