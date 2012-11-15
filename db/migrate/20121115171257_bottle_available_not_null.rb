class BottleAvailableNotNull < ActiveRecord::Migration
  def up
    execute <<-SQL
      delete from bottles where available is null
    SQL
    execute <<-SQL2
      alter table bottles alter column available set not null
    SQL2
  end

  def down
    execute <<-SQL
      alter table bottles alter column available drop not null
    SQL
  end
end
