class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :event_id
      t.string :name
      t.text :description
      t.integer :user_id

      t.timestamps
    end
  end
end
