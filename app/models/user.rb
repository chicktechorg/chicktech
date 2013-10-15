class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ROLES = %w[volunteer admin super_admin]

  validates_presence_of :first_name
  validates_presence_of :last_name      
  validates_presence_of :phone
  validates_presence_of :role
end
