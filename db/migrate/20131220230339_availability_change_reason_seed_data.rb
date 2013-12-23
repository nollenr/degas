class AvailabilityChangeReasonSeedData < ActiveRecord::Migration
  def up
    AvailabilityChangeReasonLookup.create(reason: "Drank")
    AvailabilityChangeReasonLookup.create(reason: "Spoiled")
    AvailabilityChangeReasonLookup.create(reason: "Gift")
    AvailabilityChangeReasonLookup.create(reason: "Other")
  end

  def down
    AvailabilityChangeReasonLookup.delete_all
  end
end
