class MatchesController < ApplicationController
	def index
		@tapiwinrate = []
		(1..5).each do |i|
			@tapiwinrate[i-1] = Match.GetTapiWinRate Match.where(:tapiplayers => i);
		end
		@matches = Match.all.order("matchid DESC").take 25
		@matches.each do |m|
			puts m.starttime
		end
	end
	def CalcAwards match
		ret = {}
		match.match_participations.each do |m|
			ret[m.id] = []
		end
		sorted = match.match_participations.sort_by { |p| p.herodamage.to_f / (p.kills+1) }
		ret[sorted.first.id] << {:text => "Kill Securing award (#{(sorted.first.herodamage.to_f / sorted.first.kills).round(2)} damage per kill)"}
		ret[sorted.last.id] << {:text => "Die, damn you, die! award (#{(sorted.last.herodamage.to_f / sorted.last.kills).round(2)} damage per kill)"}

		sorted = sorted.sort_by!{|m| m.tfc}.reverse!
		ret[sorted.first.id] << {:text => "Playmaker award (Participated in #{(100*sorted.first.tfc).round(2)}% of team's kills)"}
		ret[sorted.last.id] << {:text => "What is tp scroll? award (Participated in #{(100*sorted.last.tfc).round(2)}% of team's kills)"}

		return ret
	end
	def show
		@match = Match.find params[:id]
		gon.damagechartdata = CreatePieChartData @match
		gon.radiant_timeseries = []
		gon.dire_timeseries = []
		@match.match_participations.each do |mp|
			if mp.radiant
				gon.radiant_timeseries << mp.time_series
			else
				gon.dire_timeseries << mp.time_series
			end
		end
		@awards = CalcAwards @match
	end
	def CreatePieChartData match
		participations = match.match_participations
		data = {:radiant => [], :dire => []};
		(0..4).each do |i|
			if participations[i].player.name == "Non-Tapiiri"
				playername = participations[i].hero.name
			else
				playername = participations[i].player.name
			end
			data[:radiant].push ({:player => playername, :herodamage => participations[i].herodamage, :towerdamage => participations[i].towerdamage, :gold => participations[i].gpm})
		end
		(5..9).each do |i|
			if participations[i].player.name == "Non-Tapiiri"
				playername = participations[i].hero.name
			else
				playername = participations[i].player.name
			end
			data[:dire].push ({:player => playername, :herodamage => participations[i].herodamage, :towerdamage => participations[i].towerdamage, :gold => participations[i].gpm})
		end
		data
	end
end
