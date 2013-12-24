class AvailabilityChangeReasonSeedData < ActiveRecord::Migration
  def up
    AvailabilityChangeReasonLookup.create(reason: "Consumed", display_order: 10)
    AvailabilityChangeReasonLookup.create(reason: "Spoiled", display_order: 20)
    AvailabilityChangeReasonLookup.create(reason: "Gift", display_order: 30)
    AvailabilityChangeReasonLookup.create(reason: "Lost", display_order: 40)
    AvailabilityChangeReasonLookup.create(reason: "Other", display_order: 50)
  end

  def down
    AvailabilityChangeReasonLookup.delete_all
  end
end
