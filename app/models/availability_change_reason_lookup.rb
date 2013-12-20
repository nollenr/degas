class AvailabilityChangeReasonLookup < ActiveRecord::Base
  has_many :bottles
  attr_accessible :bottles, :reason
end
