class Match < ActiveRecord::Base
	has_many :match_participations
	has_and_belongs_to_many :players;

	def self.InsertMatch match, log
		m = match["match"]
		tapiplayers = 0
		radiantkills = 0
		direkills = 0
		log.info "Insertion request for match id : " + m["matchId"].to_s
		puts "Insertion request for match id : " + m["matchId"].to_s
		oldm = Match.find_by matchid: m["matchId"]
		if oldm != nil
			log.info "PRE_EXISTING " + m["matchId"].to_s
			return
		end
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
		log.info "Created MATCH for" + m["matchId"].to_s
		m["players"].each do |p|
			isRadiant = p["playerSlot"] < 128

			if isRadiant
				radiantkills += p["kills"]
			else
				direkills += p["kills"]
			end
		end
		log.info "Counted KILLS for " + m["matchId"].to_s
		m["players"].each do |p|
			player = Player.FindOrInsertPlayer(p["accountId"])
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
				dbm.players << player
			end
			dbm.kills += mp.kills
			dbm.avg_gpm += mp.gpm
			player.UpdatePlayerSum mp
		end
		dbm.tapiplayers = tapiplayers
		dbm.avg_gpm /= 10
		dbm.save
		log.info "SAVED " + m["matchId"].to_s
	end

	def self.GetTapiWinRate scope
		(scope.where("tapiwin='t'").count*100 / scope.count.to_f).round(2)	
	end
end

