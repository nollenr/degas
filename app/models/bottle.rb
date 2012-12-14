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

class Bottle < ActiveRecord::Base
  belongs_to :grape
  belongs_to :winery
  belongs_to :user
  # In order to run seed, grape_id needs to be accessible
  # attr_accessible :bottle_id, :available, :availability, :grape_id

  validates :price, allow_nil: true, numericality: { greater_than: 0.01 }
  validates :bottle_id, presence: { message: "identifier cannot be null. Bottle not created." }, uniqueness: { scope: :user_id, message: "bottle_id should be unique and this identifier was found in your history."}
  validates :user_id, presence: true
  validates :grape_id, presence: {message: "grape cannot be null.  Bottle not created." }
  attr_accessible :available, :bottle_id, :cellar_location, :vintage, :drink_by_year, :name, :vineyard, :grape_id, :winery_id, :price, :rating

  def availability
    return @availability
  end

  def availability= avail_bool
    @availability = avail_bool ? 'Available' : 'Consumed'
  end

  after_find :set_availability

  def set_availability
    self.availability= self.available
  end

end
