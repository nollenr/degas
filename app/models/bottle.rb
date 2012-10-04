class Bottle < ActiveRecord::Base
  belongs_to :grape
  attr_accessible :bottle_id, :available, :availability

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
