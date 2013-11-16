class User < ActiveRecord::Base
  attr_reader :raw_invitation_token

  validates_presence_of :first_name
  validates_presence_of :last_name      
  validates_presence_of :phone
  validates_presence_of :role

  has_many :jobs, :dependent => :nullify
  has_many :events, through: :jobs, source: :workable, source_type: 'Event', uniq: true
  has_many :teams, through: :jobs, source: :workable, source_type: 'Team', uniq: true
  has_many :event_leads, through: :leadership_roles, source: :leadable, source_type: 'Event'
  has_many :team_leads, through: :leadership_roles, source: :leadable, source_type: 'Team'
  has_many :leadership_roles
  has_many :comments

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, 
  devise :database_authenticatable, :registerable, :invitable,
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = %w[volunteer admin superadmin]

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def unique_events
    events.uniq
  end

  def unique_teams
    teams.uniq
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
