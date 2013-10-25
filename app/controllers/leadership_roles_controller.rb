class LeadershipRolesController < ApplicationController
  def destroy
    @leadership_role = LeadershipRole.find(params[:id])
    @leadable = @leadership_role.leadable
    @leadership_role.destroy
    redirect_to @leadable, notice: "#{@leadable.name} leader has resigned."
  end
end