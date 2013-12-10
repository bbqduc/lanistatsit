class SetDefaultValues < ActiveRecord::Migration
  def change
	  change_column :players, :num_matches, :integer, default: 0

	  change_column :players, :sum_gold, :integer, default: 0
	  change_column :players, :sum_gpm, :integer, default: 0
	  change_column :players, :sum_xpm, :integer, default: 0
	  change_column :players, :sum_kills, :integer, default: 0

	  change_column :players, :sum_assists, :integer, default: 0
	  change_column :players, :sum_deaths, :integer, default: 0
	  change_column :players, :sum_lasthits, :integer, default: 0
	  change_column :players, :sum_denies, :integer, default: 0
	  change_column :players, :sum_herodamage, :integer, default: 0
	  change_column :players, :sum_towerdamage, :integer, default: 0
	  change_column :players, :sum_level, :integer, default: 0
  end
end
