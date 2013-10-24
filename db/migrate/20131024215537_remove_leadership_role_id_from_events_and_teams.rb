class RemoveLeadershipRoleIdFromEventsAndTeams < ActiveRecord::Migration
  def change
    remove_column :events, :leadership_role_id, :integer
    remove_column :teams, :leadership_role_id, :integer
  end
end
