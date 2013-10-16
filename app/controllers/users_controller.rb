class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
   @user = User.find(params[:id])
   @events = Event.all
  end

end