class LeadershipRolesController < ApplicationController
  authorize_resource

  def update
    @leadership_role = LeadershipRole.find(params[:id])
    if params[:leadership_role][:signing_up]
      @leadership_role.update(user_id: current_user.id)
      flash[:notice] = "Congratulations! You have taken the lead of #{@leadership_role.leadable.name}."
      redirect_to event_path(Event.find(@leadership_role.leadable[:event_id]))
    elsif params[:leadership_role][:resigning]
      @leadership_role.update(user_id: nil)
      flash[:notice] = "The leader has resigned from #{@leadership_role.leadable.name}."
      redirect_to event_path(Event.find(@leadership_role.leadable[:event_id]))
    else
      @leadership_role.update(leadership_role_params)
      flash[:notice] = "#{@leadership_role.name} got updated."
      redirect_to event_path(Event.find(@leadership_role.leadable[:event_id]))
    end
  end

  private

  def leadership_role_params
    params.require(:leadership_role).permit(:user_id)
  end
end
