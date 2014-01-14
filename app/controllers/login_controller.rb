class LoginController < ApplicationController
  def index
  end

  def create
    if not check_login
      flash[:error]="Invalid password"
      redirect_to :controller => "login", :action => "index"
    else
      redirect_to matches_path
    end
  end

  private

  def check_login
    puts params[:name]
    puts params[:password]
    plr = Player.find_by_name(params[:name])

    plr and plr.ValidPassword(params[:password])
  end
end
