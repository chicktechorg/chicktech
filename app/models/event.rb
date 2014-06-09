class Event < ActiveRecord::Base
  default_scope { where(template: false).order(:start) }

  validates :name, :presence => true
  validates :city_id, :presence => true, :unless => :template
  validates :start, :presence => true, :timeliness => { :on_or_after => Time.now }, :unless => :template
  validates :finish, :presence => true, :timeliness => { :on_or_after => :start }, :unless => :template

  has_many :jobs, as: :workable
  has_many :teams
  has_many :team_jobs, :through => :teams, :source => :jobs
  belongs_to :city
  has_one :leadership_role, :as => :leadable, :dependent => :destroy

  attr_accessor :template_id
  accepts_nested_attributes_for :leadership_role
    accepts_nested_attributes_for :team_jobs


  def self.future
    Event.where('start >= ?', Date.today)
  end

  def self.upcoming
    time_range = (Time.now..Time.now + 1.day)
    Event.where(start: time_range)
  end

  def leader
    if leadership_role == nil
      nil
    else
      leadership_role.user
    end
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

  def number_of_available_event_jobs
    jobs.count - jobs.with_volunteers.count
  end

  def number_of_available_positions
    number_of_volunteer_positions - number_of_filled_volunteer_positions
  end

  def jobs_of_user(user)
    jobs.where(user: user)
  end

  def teams_of_user(user)
    teams.select do |team|
      team.leadership_role.user == user || team.jobs.any? { |job| job.user == user }
    end
  end

  def team_activity(user)
    past_events = Event.where("finish < ?", Time.now)
  end

  def self.past
    Event.where("finish < ?", Time.now)
  end

  def start_date
    start.to_date
  end

  def create_template
    template = self.dup :include => [{:jobs => :tasks}, {:teams => {:jobs => :tasks}}]
    template.update(template: true)
    template
  end

  def unique_volunteers
    volunteers = []
    volunteers << leader if leadership_role
    teams.each { |team| volunteers << team.leader }
    jobs.each { |j| volunteers << j.user }
    team_jobs.each { |tj| volunteers << tj.user }
    volunteers = volunteers - [nil]
    volunteers.uniq
  end
end
