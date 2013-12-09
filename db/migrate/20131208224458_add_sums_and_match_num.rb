class AddSumsAndMatchNum < ActiveRecord::Migration
  def change
	  add_column :players, :num_matches, :integer

	  add_column :players, :sum_gold, :integer
	  add_column :players, :sum_gpm, :integer
	  add_column :players, :sum_xpm, :integer
	  add_column :players, :sum_kills, :integer

	  add_column :players, :sum_assists, :integer
	  add_column :players, :sum_deaths, :integer
	  add_column :players, :sum_lasthits, :integer
	  add_column :players, :sum_denies, :integer
	  add_column :players, :sum_herodamage, :integer
	  add_column :players, :sum_towerdamage, :integer
	  add_column :players, :sum_level, :integer
  end
end
