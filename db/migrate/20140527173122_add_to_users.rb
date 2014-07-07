class AddToUsers < ActiveRecord::Migration
  def change
    add_column :users, :city, :string
    add_column :users, :gender, :string
    add_column :users, :birthday, :date
  end
end
