class AddIsRadiant < ActiveRecord::Migration
  def change
	  add_column :match_participations, :radiant, :boolean
  end
end
