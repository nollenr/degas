class AddDefaultValuesToUsers < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE users ALTER COLUMN created_at SET DEFAULT now();
      ALTER TABLE users ALTER COLUMN updated_at SET DEFAULT now();
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE users ALTER COLUMN created_at DROP DEFAULT;
      ALTER TABLE users ALTER COLUMN updated_at DROP DEFAULT;
    SQL
  end
end
