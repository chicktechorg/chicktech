class User < ActiveRecord::Base
  attr_reader :raw_invitation_token

  validates_presence_of :first_name
  validates_presence_of :last_name      
  validates_presence_of :phone
  validates_presence_of :role

  has_many :jobs, :dependent => :nullify
  has_many :events, through: :jobs, source: :workable, source_type: 'Event'
  has_many :teams, through: :jobs, source: :workable, source_type: 'Team'
  has_many :leadership_roles

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
end
