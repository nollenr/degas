class AddFkToBottles2 < ActiveRecord::Migration
  def up
    execute 'ALTER TABLE bottles ADD CONSTRAINT bottles_fk_002 FOREIGN KEY (winery_id) REFERENCES wineries(id)'
  end

  def down
    execute 'ALTER TABLE bottles DROP CONSTRAINT bottles_fk_002'
  end
end
