class LoginController < ApplicationController
  def index
  end

  def create
    plr = Player.find_by_name(params[:name])
    if not check_login plr
      flash[:error]="Invalid password"
      redirect_to :controller => "login", :action => "index"
    else
      session[:user_id] = plr.id
      redirect_to matches_path
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to matches_path
  end

  private

  def check_login plr
    plr and plr.ValidPassword(params[:password])
  end
end
