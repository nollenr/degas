class AddDisplayOrderToBottleTypes < ActiveRecord::Migration
  def change
    add_column	:bottle_types, :display_order, :integer
  end
end
