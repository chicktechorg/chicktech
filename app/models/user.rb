class User < ActiveRecord::Base
  attr_reader :raw_invitation_token

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :phone
  validates_presence_of :role

  has_many :jobs, :dependent => :nullify
  has_many :events, -> { uniq }, through: :jobs, source: :workable, source_type: 'Event'
  has_many :teams, -> { uniq }, through: :jobs, source: :workable, source_type: 'Team'
  has_many :events_through_teams, -> { uniq }, through: :teams, source: :event
  has_many :event_leads, through: :leadership_roles, source: :leadable, source_type: 'Event'
  has_many :events_through_team_leads, through: :team_leads, source: :event
  has_many :team_leads, through: :leadership_roles, source: :leadable, source_type: 'Team'
  has_many :leadership_roles, :dependent => :nullify
  has_many :comments
  belongs_to :city

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable,
  devise :database_authenticatable, :registerable, :invitable,
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = %w[volunteer admin superadmin]

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def past_events_led
    event_leads.past.count
  end

  def past_teams_led
    team_leads.reject { |t| t.event.finish > Time.now }.count
  end

  def past_jobs
    jobs.reject { |j| j.get_event.finish > Time.now }.count
  end

  def commitment_events
    all_events.sort
  end

  def all_events
    (events_through_teams.upcoming + events_through_team_leads.upcoming + event_leads.upcoming + events.upcoming).uniq
  end

  def all_teams
    (team_leads + teams).uniq
  end

  def send_information
    UserMailer.send_information(self).deliver
  end

  def self.pending
    User.where("invitation_token IS NOT NULL")
  end

  def self.confirmed
    User.where("invitation_token IS NULL")
  end
end
