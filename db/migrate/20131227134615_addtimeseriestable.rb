class Addtimeseriestable < ActiveRecord::Migration
  def change
	  create_table :time_series do |t|
		  t.integer :minute
		  t.integer :xp
		  t.integer :gold
		  t.integer :lasthits
		  t.integer :denies
	  end
	  add_reference :time_series, :match_participation, index: false
	  add_index :time_series, [:match_participation_id, :minute]
  end
end
