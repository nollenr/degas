class AddFucntionAndTriggerOnUsernameToUser < ActiveRecord::Migration
  def change
    execute <<-TRIGGER
      CREATE OR REPLACE FUNCTION set_users_username_lowercase() RETURNS trigger AS
        $BODY$Begin
          NEW.username = LOWER(NEW.username);
          return NEW;
        end;$BODY$
      LANGUAGE plpgsql STABLE NOT LEAKPROOF COST 100;

      DROP TRIGGER IF EXISTS trigger_set_users_username_lowercase ON users;

      CREATE TRIGGER trigger_set_users_username_lowercase
        BEFORE INSERT OR UPDATE OF username ON users
          FOR EACH ROW EXECUTE PROCEDURE set_users_username_lowercase();

    TRIGGER
  end
end
