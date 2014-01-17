require 'curb'
require 'json'
require 'open-uri'
require 'nokogiri'
require 'pty'

class Match < ActiveRecord::Base
	has_many :match_participations
	has_and_belongs_to_many :players;

	def FetchReplay
		if self.match_participations[0].time_series.count != 0
			return
		end

		rep_path = Rails.root.join('db', 'fetched_replays', matchid.to_s + ".dem.bz2")
		if(!rep_path.exist?)
			repurl = ""
			if(self.replayurl != nil)
				repurl = self.replayurl
			else
				url = "https://rjackson.me/tools/matchurls?matchid=" + self.matchid.to_s
				page = Nokogiri::HTML(open url)
				repurl = page.css('input')[0].attributes["value"].value
			end

			puts "Got repurl : " + repurl

			File.open(rep_path, "wb") do |saved_file|
				begin
					open(repurl, "rb") do |read_file|
						saved_file.write(read_file.read)
					end
				rescue OpenURI::HTTPError
					return
				end
			end
		end
		
		ReplayParser.new.perform self.id rep_path
	end

	def self.GetNewTapiMatches
		matchids = []
		Player.tapiplayers.each do |p|
			matchids += p.GetNewMatchIds
			sleep 1;
		end

		matchids.each do |m|
			if FetchMatchFromWebAPI m
				sleep 1;
			end
		end
	end

	def self.FetchMatchFromWebAPI matchid
		oldm = Match.find_by matchid: matchid
		if oldm != nil
			return false
		end

		steamapikey=IO.read Rails.root.join("steamapikey")
		url = "https://api.steampowered.com/IDOTA2Match_570/GetMatchDetails/V001/?match_id=" + matchid.to_s + "&key=" + steamapikey
		c = Curl::Easy.new url
		c.perform
		s = c.body_str
		replay_path=Rails.root.join('public', 'replays')
		FileUtils.mkdir(replay_path) unless File.directory? replay_path
		IO.write Rails.root.join(replay_path, matchid.to_s + ".json"), s
		o = JSON.parse s
		InsertMatchFromWebAPI o, Logger.new(STDOUT)
		return true
	end

	def self.InsertMatchFromWebAPI match, log
		m = match["result"]
		tapiplayers = 0
		radiantkills = 0
		direkills = 0
		log.info "Insertion request for match id : " + m["match_id"].to_s
		puts "Insertion request for match id : " + m["match_id"].to_s
		oldm = Match.find_by matchid: m["match_id"]
		if oldm != nil
			log.info "PRE_EXISTING " + m["match_id"].to_s
			return
		end
		if m["first_blood_time"] == 0
			return
		end
		dbm = Match.create ({ :matchid => m["match_id"],
						:towerstatus_radiant => m["tower_status_radiant"],
						:towerstatus_dire => m["tower_status_dire"],
						:barracksstatus_radiant => m["barracks_status_radiant"],
						:barracksstatus_dire => m["barracks_status_dire"],
						:firstbloodtime => m["first_blood_time"],
						:gamemode => m["game_mode"],
						:radiant_win => m["radiant_win"],
						:duration => m["duration"],
						:starttime => (Time.at m["start_time"]),
						:replayurl => nil,
						:tapiplayers => 0
		})
		log.info "Created MATCH for" + m["match_id"].to_s
		m["players"].each do |p|
			isRadiant = p["player_slot"] < 128

			if isRadiant
				radiantkills += p["kills"]
			else
				direkills += p["kills"]
			end
		end
		log.info "Counted KILLS for " + m["match_id"].to_s
		m["players"].each do |p|
			player = Player.FindOrInsertPlayer(p["account_id"])
			isRadiant = p["player_slot"] < 128
			teamkills = isRadiant ? radiantkills : direkills
			tfc = teamkills == 0 ? 1.0 : (p["kills"] + p["assists"]) / teamkills.to_f


			hero = Hero.find_by heroid: p["hero_id"]
			mp = MatchParticipation.create ({ 
				:match_id => dbm.id,
				:player_id => player.id,
				:hero_id => hero != nil ? hero.id : nil,
				:kills => p["kills"],
				:assists => p["assists"],
				:deaths => p["deaths"],
				:finishgold => p["gold"],
				:goldspent => p["gold_spent"],
				:lasthits => p["last_hits"],
				:denies => p["denies"],
				:gpm => p["gold_per_min"],
				:xpm => p["xp_per_min"],
				:herodamage => p["hero_damage"],
				:towerdamage => p["tower_damage"],
				:herohealing => p["hero_healing"],
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
		log.info "SAVED " + m["match_id"].to_s
		dbm.FetchReplay()
	end

	def self.InsertMatchFromJorn match, log
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
		dbm.FetchReplay()
	end

	def self.GetTapiWinRate scope
		(scope.where("tapiwin='t'").count*100 / scope.count.to_f).round(2)	
	end

	def ProcessReplayInfo info
		mps = self.match_participations
		if mps[0].time_series.count != 0
			return
		end
		info.each do |i|
			hero = Hero.find_by heroid: i["hero"]
			mp = mps.find_by hero_id: hero.id
			return false unless mp

			i["gold"].each_index do |j|
				TimeSeries.create(
					:match_participation_id => mp.id,
					:minute => j,
					:gold => i["gold"][j],
					:xp => i["xp"][j],
					:lasthits => i["lasthits"][j],
					:denies => i["denies"][j]
				);
			end
		end
    return true
	end

	def UrlForReplay
		path = Pathname.new(self.replay_path)
		File.join('/replays', path.basename)
	end
end

