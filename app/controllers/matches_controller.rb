class MatchesController < ApplicationController
	def index
		@tapiwinrate = Match.GetTapiWinRate Match
		@matches = Match.all.order("matchid DESC").take 25
		@matches.each do |m|
			puts m.starttime
		end
	end
	def show
		@match = (Match.where :id => params[:id])[0]
		gon.damagechartdata = CreatePieChartData @match
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
