class PlayersController < ApplicationController
	def index
		@players = Player.all
	end
	def show
		@player = (Player.where :id => params[:id])[0]
		@tapiwinrate = Match.GetTapiWinRate @player.matches
		@matches = @player.matches.take 25
	end
end
