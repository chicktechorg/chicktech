class AddDoneToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :done, :boolean
  end
end
