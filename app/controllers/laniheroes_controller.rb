class LaniheroesController < ApplicationController
  def index
    @players = Player.tapiplayers
  end

  def new
  end

  def create
    Lanihero.create(
      :player_id => session[:user_id],
      :hero_id   => params[:lanihero][:hero_id],
      :comment   => params[:lanihero][:comment]
    )
    flash[:notice]="Lanihero created"
    redirect_to :controller => :players, :action => :show, :id => session[:user_id]
  end

  def destroy
    hero = Lanihero.find(params[:id])
    if hero.player_id == session[:user_id]
      flash[:notice]="Lanihero deleted"
      hero.destroy
    end
    redirect_to player_path(session[:user_id])
  end
end
