class Bottle < ActiveRecord::Base
  belongs_to :grape
  # In order to run seed, grape_id needs to be accessible
  # attr_accessible :bottle_id, :available, :availability, :grape_id
  attr_accessible :bottle_id, :available

  after_find :set_availability

  def set_availability
    if self.available 
			#puts "And the bottle is available"
      self[:availability] =  'Available'
    else
      #puts "And the bottle is UNavailable"
      self[:availability] =  'Consumed'
    end
  end

end
