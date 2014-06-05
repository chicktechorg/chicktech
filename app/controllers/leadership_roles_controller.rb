class LeadershipRolesController < ApplicationController
  authorize_resource

  def update
    @leadership_role = LeadershipRole.find(params[:id])
    if params[:leadership_role][:signing_up]
      @leadership_role.update(user_id: current_user.id)
      flash[:notice] = "Congratulations! You have taken the lead of #{@leadership_role.leadable.name}."
    elsif params[:leadership_role][:resigning]
      @leadership_role.update(user_id: nil)
      flash[:notice] = "The leader has resigned from #{@leadership_role.leadable.name}."
    else
      @leadership_role.update(leadership_role_params)
      flash[:notice] = "#{@leadership_role.name} got updated."
    end
    redirect_to event_path(@leadership_role.get_event)
  end

  private

  def leadership_role_params
    params.require(:leadership_role).permit(:user_id)
  end
end
