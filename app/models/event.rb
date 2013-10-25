class Event < ActiveRecord::Base
  validates :name, :presence => true
  validates :start, :presence => true, :timeliness => { :on_or_after => Time.now }
  validates :finish, :presence => true, :timeliness => { :on_or_after => :start }

  has_many :jobs, as: :workable
  has_many :teams
  belongs_to :city
  has_one :leadership_role, :as => :leadable

  accepts_nested_attributes_for :leadership_role

  def self.upcoming
    Event.where("start > ?", Time.now)
  end

  def leader
    leadership_role.user
  end
end
