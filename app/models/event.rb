class Event < ActiveRecord::Base
  default_scope { order(:start) }

  validates :name, :presence => true
  validates :city_id, :presence => true
  validates :start, :presence => true, :timeliness => { :on_or_after => Time.now }
  validates :finish, :presence => true, :timeliness => { :on_or_after => :start }

  has_many :jobs, as: :workable
  has_many :teams
  has_many :team_jobs, :through => :teams, :source => :jobs
  belongs_to :city
  has_one :leadership_role, :as => :leadable, :dependent => :destroy

  accepts_nested_attributes_for :leadership_role

  def self.upcoming
    time_range = (Time.now..Time.now + 1.day)
    Event.where(start: time_range)
  end

  def leader
    leadership_role.user
  end

  def all_jobs
    jobs + team_jobs
  end

  def number_of_jobs
    all_jobs.count
  end

  def number_of_jobs_with_volunteers
    jobs.with_volunteers.count + team_jobs.with_volunteers.count
  end

  def number_of_teams
    teams.count
  end

  def number_of_teams_with_leaders
    teams.with_leaders.count
  end

  def number_of_volunteer_positions
    number_of_jobs + number_of_teams
  end

  def number_of_filled_volunteer_positions
    number_of_jobs_with_volunteers + number_of_teams_with_leaders
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

  def start_date
    start.to_date
  end
end
