class AddUniqueIndexes < ActiveRecord::Migration
  def change
	  add_index "players", ["accountid"], {:unique => true}
	  add_index "matches", ["matchid"], {:unique => true}
  end
end
