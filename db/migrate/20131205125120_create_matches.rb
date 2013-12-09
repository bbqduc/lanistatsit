class CreateMatches < ActiveRecord::Migration

  def change
    create_table :matches do |t|
      t.integer :matchid
      t.integer :towerstatus_radiant
      t.integer :towerstatus_dire
      t.integer :barracksstatus_radiant
      t.integer :barracksstatus_dire
      t.integer :firstbloodtime
      t.string :gamemode
      t.boolean :radiant_win
      t.integer :duration
      t.datetime :starttime
      t.string :replayurl
	  t.integer :tapiplayers

      t.timestamps
    end

    create_table :players do |t|
      t.integer :accountid
	  t.string :name

      t.timestamps
    end

    create_table :match_participations do |t|

	  t.belongs_to :match
	  t.belongs_to :player

	  t.integer :kills
	  t.integer :assists
	  t.integer :deaths
	  t.integer :finishgold
	  t.integer :goldspent
	  t.integer :lasthits
	  t.integer :denies
	  t.integer :gpm
	  t.integer :xpm
	  t.integer :herodamage
	  t.integer :towerdamage
	  t.integer :herohealing
	  t.integer :level

      t.timestamps
    end
	
  end
end
