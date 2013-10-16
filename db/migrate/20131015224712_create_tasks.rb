class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :job_id
      t.text :description
      t.boolean :done

      t.timestamps
    end
  end
end
