# == Schema Information
#
# Table name: bottles
#
#  id                          :integer          not null, primary key
#  bottle_id                   :integer          not null
#  grape_id                    :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  available                   :boolean          default(TRUE), not null
#  availability_change_date    :datetime
#  availability_change_message :string(255)
#  winery_id                   :integer
#  vintage                     :string(4)
#  drink_by_year               :string(4)
#  vineyard                    :string(255)
#  name                        :string(255)
#  cellar_location             :string(30)
#  price                       :decimal(8, 2)
#  user_id                     :integer          not null
#

require 'spec_helper'

describe Bottle do
  pending "add some examples to (or delete) #{__FILE__}"
end
