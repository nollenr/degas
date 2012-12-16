# == Schema Information
#
# Table name: grapes
#
#  id          :integer          not null, primary key
#  name        :string(100)      not null
#  color       :string(10)       not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Grape < ActiveRecord::Base
  has_many :bottles
  attr_accessible :color, :name

  Color = Grape.select(:color).uniq
end
