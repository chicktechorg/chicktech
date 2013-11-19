class AddDueDateToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :due_date, :datetime
  end
end
