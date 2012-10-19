class Bottle < ActiveRecord::Base
  belongs_to :grape
  belongs_to :winery
  # In order to run seed, grape_id needs to be accessible
  # attr_accessible :bottle_id, :available, :availability, :grape_id

  validates :price, allow_nil: true, numericality: { greater_than: 0.01 }
  attr_accessible :available, :bottle_id, :cellar_location, :vintage, :drink_by_year, :name, :vineyard, :grape_id, :winery_id, :price

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
