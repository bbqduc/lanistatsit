class CreateLaniheros < ActiveRecord::Migration
  def change
    create_table :laniheros do |t|
      t.integer :hero_id
      t.integer :player_id

      t.text :comment

      t.timestamps
    end
  end
end
