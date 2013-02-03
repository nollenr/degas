class AddFkOnUseridToBottles < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE bottles ADD CONSTRAINT bottles_fk_004 FOREIGN KEY (user_id) REFERENCES users(id)'
  end

  def down
    execute 'ALTER TABLE bottles DROP CONSTRAINT bottles_fk_004'
  end
end
