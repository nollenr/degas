class BlendCompositionForeignKeys < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE blend_compositions
        ADD CONSTRAINT blend_compositions_fk_001 FOREIGN KEY (blend_id)
            REFERENCES blends (id) MATCH SIMPLE
            ON UPDATE NO ACTION ON DELETE NO ACTION;
      ALTER TABLE blend_compositions
        ADD CONSTRAINT blend_compositions_fk_002 FOREIGN KEY (grape_id)
            REFERENCES grapes (id) MATCH SIMPLE
            ON UPDATE NO ACTION ON DELETE NO ACTION;
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE blend_compositions DROP CONSTRAINT blend_compositions_fk_001;
      ALTER TABLE blend_compositions DROP CONSTRAINT blend_compositions_fk_002;
    SQL
  end

end
