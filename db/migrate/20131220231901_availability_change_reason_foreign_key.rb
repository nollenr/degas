class AvailabilityChangeReasonForeignKey < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE bottles
        ADD CONSTRAINT bottles_fk_005 FOREIGN KEY (availability_change_reason_id)
            REFERENCES availability_change_reason_lookups (id) MATCH SIMPLE
            ON UPDATE NO ACTION ON DELETE NO ACTION;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE bottles DROP CONSTRAINT bottles_fk_005;
    SQL
  end
end
