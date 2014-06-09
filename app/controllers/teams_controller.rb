class TeamsController < ApplicationController
  def new
    @team = Team.new(team_params)
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      respond_to do |format|
        format.html { redirect_to @team.event, notice: 'Team added!' }
        format.js
      end
    else
      render :new
    end
  end

  def show
    @team = Team.find(params[:id])
    @job = Job.new(:workable => @team)
    @comment = Comment.new(:commentable => @team)
    @commentable = @team
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    @event = @team.event
    if @team.update(team_params)
      respond_to do |format|
        format.html { redirect_to @team.event, notice: 'Team added!' }
        format.js
      end
    else
      render :edit
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    redirect_to @team.event, notice: 'Team deleted.'
  end

private

  def team_params
    params.require(:team).permit(:name, :event_id)
  end
end
