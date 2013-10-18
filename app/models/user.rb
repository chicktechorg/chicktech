class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, 
  devise :database_authenticatable, :registerable, :invitable,
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = %w[volunteer admin superadmin]

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  validates_presence_of :first_name
  validates_presence_of :last_name      
  validates_presence_of :phone
  validates_presence_of :role

  has_many :jobs
  has_many :events, through: :jobs

  def unique_events
    @events = Event.all
    self.events.uniq
  end

  # def send_welcome
  #   UserMailer.welcome_email(self).deliver
  # end

  def send_information
    UserMailer.send_information(self).deliver
  end
end
