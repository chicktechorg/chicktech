class Team < ActiveRecord::Base
  validates :name, presence: true

  has_many :jobs, :as => :workable
  belongs_to :event
  has_one :leadership_role, :as => :leadable, :dependent => :destroy

  after_create :create_leadership_role

  def leader
    leadership_role.user
  end

  def jobs_of_user(user)
    jobs.where(user: user)
  end

private

  def create_leadership_role
    LeadershipRole.create(:leadable => self)
  end
end
