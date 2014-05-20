class Team < ActiveRecord::Base
  validates :name, presence: true
  has_many :comments, :as => :commentable
  has_many :jobs, :as => :workable
  belongs_to :event
  has_one :leadership_role, :as => :leadable, :dependent => :destroy
  has_one :leader, :through => :leadership_role, :source => :user

  after_create :create_leadership_role

  def leader_name
    leadership_role.user.first_name
  end

  def jobs_of_user(user)
    jobs.where(user: user)
  end

  def self.with_leaders
    select { |team| team.leader != nil }
  end
private

  def create_leadership_role
    LeadershipRole.create(:leadable => self)
  end
end
