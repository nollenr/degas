class AddFunctionAndTriggerOnAvailableToBottles < ActiveRecord::Migration
  def change
    execute <<-TRIGGER
CREATE OR REPLACE FUNCTION update_bottle_availability_date() RETURNS trigger AS
$BODY$Begin
  -- first check to see if I'm updating the available column
  -- be sure the value is actually changing.
  if (NEW.available != OLD.available) or (NEW.available IS NULL and OLD.available IS NOT NULL) or (NEW.available IS NOT NULL and OLD.available IS NULL) THEN
    -- check to see if (new) availability_change_date has a value
    -- and that the value doesn't equal the old value.
    if (NEW.availability_change_date IS NULL) or (NEW.availability_change_date = OLD.availability_change_date) THEN
      NEW.availability_change_date = LOCALTIMESTAMP;
    end if;
  end if;
  return NEW;
end;$BODY$
LANGUAGE plpgsql STABLE NOT LEAKPROOF
COST 100;

DROP TRIGGER IF EXISTS supply_bottle_availability_change_date ON bottles;

CREATE TRIGGER supply_bottle_availability_change_date
  BEFORE UPDATE OF available
  ON bottles
  FOR EACH ROW
  EXECUTE PROCEDURE update_bottle_availability_date();

TRIGGER
  end
end
