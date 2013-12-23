class PlayersController < ApplicationController
	def index
		@players = Player.all
	end
	def show
		@player = (Player.where :id => params[:id])[0]
		@tapiwinrate = Match.GetTapiWinRate @player.matches
		@matches = @player.matches.all.sort_by!{|m| m.matchid }.reverse!.take 25
	end
end
