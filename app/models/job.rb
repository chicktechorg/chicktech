class Job < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  validates_presence_of :name
  validates_presence_of :event_id
end