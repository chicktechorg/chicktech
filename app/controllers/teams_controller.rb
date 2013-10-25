class TeamsController < ApplicationController
  def new
    @team = Team.new(team_params)
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      redirect_to @team.event, notice: 'Team added!'
    else
      render :new
    end
  end

  def show
    @team = Team.find(params[:id])
    @job = Job.new(:workable => @team)
    @leadership_role = LeadershipRole.new(:leadable => @team)
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    if @team.update(team_params)
      redirect_to @team, notice: 'Team updated!'
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
