class ChangeUsersInvitationTokenBack < ActiveRecord::Migration
  def change
    change_column :users, :invitation_token, :string
  end
end
