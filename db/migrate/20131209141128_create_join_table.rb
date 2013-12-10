class CreateJoinTable < ActiveRecord::Migration
  def change
	  create_table "matches_players", :id => false do |t|
		  t.column "match_id", :integer, :null => false
		  t.column "player_id", :integer, :null => false
	  end
  end
end
