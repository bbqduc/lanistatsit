# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'json'

s = IO.read "db/seed_data.json"
matches = JSON.parse s

def InsertTapiiris
	Player.create({:accountid => 20684381,
				:name => "bduc"})
	Player.create({:accountid => 34891907,
				:name => "Zmo"})
	Player.create({:accountid => 9196866,
				:name => "motonen"})
	Player.create({:accountid => 25590587,
				:name => "torttuPmies"})
	Player.create({:accountid => 82009679,
				:name => "XermoS"})
	Player.create({:accountid => 0,
				:name => "Non-Tapiiri"})
end

def InsertHeroes
	s = IO.read Rails.root.join('db', 'heroids.json')
	heroes = JSON.parse s
	heroes["result"]["heroes"].each do |h|
		Hero.create ({:heroid => h["id"],
				:name => h["localized_name"]
		})
	end
end

def FindOrInsertPlayer id
	p = Player.where ({:accountid => id})
	if p == nil || p == []
		p = Player.where ({:accountid => 0})
	end
	return p.first
end

def UpdatePlayerSum player, mp
	player.num_matches += 1
	player.matches << mp.match
	player.sum_herodamage += mp.herodamage
	player.sum_towerdamage += mp.towerdamage
	player.sum_gold += mp.goldspent + mp.finishgold
	player.sum_gpm += mp.gpm
	player.sum_xpm += mp.xpm
	player.sum_kills += mp.kills
	player.sum_assists += mp.assists
	player.sum_deaths += mp.deaths
	player.sum_lasthits += mp.lasthits
	player.sum_denies += mp.denies
	player.sum_level += mp.level
	player.sum_tfc += mp.tfc
	player.save
end

def InsertMatch match
	m = match["match"]
	tapiplayers = 0
	radiantkills = 0
	direkills = 0
	dbm = Match.create ({ :matchid => m["matchId"],
					:towerstatus_radiant => m["towerStatus"][0],
					:towerstatus_dire => m["towerStatus"][1],
					:barracksstatus_radiant => m["barracksStatus"][0],
					:barracksstatus_dire => m["barracksStatus"][1],
					:firstbloodtime => m["firstBloodTime"],
					:gamemode => m["gameMode"],
					:radiant_win => m["goodGuysWin"],
					:duration => m["duration"],
					:starttime => (Time.at m["startTime"]),
					:replayurl => ("http://replay" + m["cluster"].to_s + ".valve.net/570/" + m["matchId"].to_s + "_" + m["replaySalt"].to_s + ".dem.bz2" ),
					:tapiplayers => 0
	})
	m["players"].each do |p|
		isRadiant = p["playerSlot"] < 128

		if isRadiant
			radiantkills += p["kills"]
		else
			direkills += p["kills"]
		end
	end
	m["players"].each do |p|
		player = FindOrInsertPlayer(p["accountId"])
		isRadiant = p["playerSlot"] < 128
		teamkills = isRadiant ? radiantkills : direkills
		tfc = teamkills == 0 ? 1.0 : (p["kills"] + p["assists"]) / teamkills.to_f


		hero = Hero.find_by heroid: p["heroId"]
		mp = MatchParticipation.create ({ 
							   :match_id => dbm.id,
							   :player_id => player.id,
							   :hero_id => hero.id,
							   :kills => p["kills"],
							   :assists => p["assists"],
							   :deaths => p["deaths"],
							   :finishgold => p["gold"],
							   :goldspent => p["goldSpent"],
							   :lasthits => p["lastHits"],
							   :denies => p["denies"],
							   :gpm => p["goldPerMin"],
							   :xpm => p["xPPerMin"],
							   :herodamage => p["heroDamage"],
							   :towerdamage => p["towerDamage"],
							   :herohealing => p["heroHealing"],
							   :level => p["level"],
							   :radiant => isRadiant,
							   :win => isRadiant ? dbm.radiant_win : !dbm.radiant_win,
							   :tfc => tfc
		})
		if player.accountid != 0
			tapiplayers += 1
			dbm.tapiwin = mp.win
		end
		dbm.players << player
		dbm.kills += mp.kills
		UpdatePlayerSum player, mp
	end
	dbm.tapiplayers = tapiplayers
	dbm.save
end

InsertHeroes()
InsertTapiiris()
matches.each { |m| InsertMatch m }
