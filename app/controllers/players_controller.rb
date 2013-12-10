class PlayersController < ApplicationController
	def index
		@players = Player.all
	end
	def show
		@player = (Player.where :id => params[:id])[0]
		@matches = @player.matches
	end
end
