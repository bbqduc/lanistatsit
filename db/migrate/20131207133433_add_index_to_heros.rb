class AddIndexToHeros < ActiveRecord::Migration
  def change
	  add_index :heros, [:heroid], {:unique => true}
  end
end
