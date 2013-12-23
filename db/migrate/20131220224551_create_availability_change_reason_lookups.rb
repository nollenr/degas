class CreateAvailabilityChangeReasonLookups < ActiveRecord::Migration
  def change
    create_table :availability_change_reason_lookups do |t|
      t.string :reason, null: false, limit: 50
      t.integer :display_order, null: false
      t.timestamps
    end
  end
end
