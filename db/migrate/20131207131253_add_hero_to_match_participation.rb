class AddHeroToMatchParticipation < ActiveRecord::Migration
  def change
	  change_table :match_participations do |t|
		  t.belongs_to :hero
	  end
  end
end
