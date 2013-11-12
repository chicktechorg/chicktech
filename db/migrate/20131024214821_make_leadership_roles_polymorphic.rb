class MakeLeadershipRolesPolymorphic < ActiveRecord::Migration
  def change
    change_table :leadership_roles do |t|
      t.references :leadable, :polymorphic => true
    end
  end
end
