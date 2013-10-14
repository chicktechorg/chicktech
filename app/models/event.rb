class Event < ActiveRecord::Base
  validates :name, :presence => true
  validates :start, :presence => true
  validates :finish, :presence => true
end
