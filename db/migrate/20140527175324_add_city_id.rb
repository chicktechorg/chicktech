class AddCityId < ActiveRecord::Migration
  def change
    remove_column :users, :city
    add_column :users, :city_id, :integer
  end
end
