class LaniheroesController < ApplicationController
  def index
    @players = Player.tapiplayers
  end
end
