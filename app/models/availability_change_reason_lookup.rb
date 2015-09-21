class AvailabilityChangeReasonLookup < ActiveRecord::Base
  has_many :bottles
  attr_accessible :reason, :display_order
end
