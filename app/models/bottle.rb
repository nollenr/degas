class Bottle < ActiveRecord::Base
  belongs_to :grape
  belongs_to :winery
  # In order to run seed, grape_id needs to be accessible
  # attr_accessible :bottle_id, :available, :availability, :grape_id
  attr_accessible :available

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
