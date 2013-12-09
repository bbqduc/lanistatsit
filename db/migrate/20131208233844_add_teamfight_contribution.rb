class AddTeamfightContribution < ActiveRecord::Migration
  def change
	  add_column :players, :sum_tfc, :float, default: 0.0
	  add_column :match_participations, :tfc, :float, default: 0.0
  end
end
