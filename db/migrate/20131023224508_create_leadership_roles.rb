class CreateLeadershipRoles < ActiveRecord::Migration
  def change
    create_table :leadership_roles do |t|
      t.belongs_to :user
      t.string :name

      t.timestamps
    end
    add_column :events, :leadership_role_id, :integer
  end
end
