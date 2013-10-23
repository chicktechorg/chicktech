class Event < ActiveRecord::Base
  validates :name, :presence => true
  validates :start, :presence => true, :timeliness => { :on_or_after => Time.now }
  validates :finish, :presence => true, :timeliness => { :on_or_after => :start }
  has_many :jobs, as: :workable
  belongs_to :city

  def self.upcoming
    Event.where("start > ?", Time.now)
  end
end
