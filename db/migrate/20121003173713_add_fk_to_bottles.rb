class AddFkToBottles < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE bottles ADD CONSTRAINT bottles_fk_001 FOREIGN KEY (grape_id) REFERENCES grapes(id)'
  end

  def down
    execute 'ALTER TABLE bottles DROP CONSTRAINT bottles_fk_001'
  end
end
