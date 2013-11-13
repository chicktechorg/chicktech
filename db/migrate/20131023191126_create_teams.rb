class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :event_id
      t.integer :leadership_role_id

      t.timestamps
    end
  end
end
