class ChangeUsersInvitationToken < ActiveRecord::Migration
  def change
    change_column :users, :invitation_token, :string, :limit => 60
  end
end
