class AddBottleTypeIdToBottles < ActiveRecord::Migration
  def up
    add_column :bottles, :bottle_type_id, :integer, null: true

    execute <<-SQL
      ALTER TABLE bottles
        ADD CONSTRAINT bottles_fk_003 FOREIGN KEY (bottle_type_id)
            REFERENCES bottle_types (id) MATCH SIMPLE
            ON UPDATE NO ACTION ON DELETE NO ACTION;
    SQL

    Bottle_type.find_or_create_by_name("Wine")

    execute <<-SQL
      UPDATE bottles SET bottle_type_id = (SELECT id FROM bottle_types WHERE name = 'Wine');
    SQL

    change_column :bottles, :bottle_type_id, :integer, null: false
  end

  def down
    execute <<-SQL
      ALTER TABLE bottles DROP CONSTRAINT bottles_fk_003;
    SQL
    remove_column :bottles, :bottle_type_id
  end
end



