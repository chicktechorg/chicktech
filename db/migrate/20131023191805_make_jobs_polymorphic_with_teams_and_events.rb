class MakeJobsPolymorphicWithTeamsAndEvents < ActiveRecord::Migration
  def change
    change_table :jobs do |t|
      t.remove :event_id
      t.references :workable, :polymorphic => true
    end
  end
end
