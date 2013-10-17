class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, :registerable
  devise :database_authenticatable,
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
end
