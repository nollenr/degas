class AvailabilityChangeReasonUniqueIndex < ActiveRecord::Migration
  def change
    add_index(:availability_change_reason_lookups, :reason, unique: true)
    add_index(:availability_change_reason_lookups, :display_order, unique: true)
  end
end
