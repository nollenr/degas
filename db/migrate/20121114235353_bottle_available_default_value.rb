class BottleAvailableDefaultValue < ActiveRecord::Migration
  def up
    execute <<-SQL
      alter table bottles alter column available set default true
    SQL
  end

  def down
    execute <<-SQL
      alter table bottles alter column available set default null
    SQL
  end
end
