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
  has_many :blend_compositions
  has_many :blends, through: :blend_compositions

  attr_accessible :color, :name
end
