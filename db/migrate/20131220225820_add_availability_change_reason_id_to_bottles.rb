class AddAvailabilityChangeReasonIdToBottles < ActiveRecord::Migration
  def change
    add_column :bottles, :availability_change_reason_id, :integer
  end
end
