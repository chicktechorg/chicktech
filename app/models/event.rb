class Event < ActiveRecord::Base
  default_scope { order(:start) }

  validates :name, :presence => true
  validates :city_id, :presence => true
  validates :start, :presence => true, :timeliness => { :on_or_after => Time.now }
  validates :finish, :presence => true, :timeliness => { :on_or_after => :start }

  has_many :jobs, as: :workable
  has_many :teams
  belongs_to :city
  has_one :leadership_role, :as => :leadable, :dependent => :destroy

  accepts_nested_attributes_for :leadership_role

  def self.upcoming
    Event.where("finish > ?", Time.now)
  end

  def leader
    leadership_role.user
  end

  def jobs_of_user(user)
    jobs.where(user: user)
  end

  def teams_of_user(user)
    teams.select do |team|
      team.leadership_role.user == user || team.jobs.any? { |job| job.user == user }
    end
  end

  def self.past
    Event.where("finish < ?", Time.now)
  end
end
