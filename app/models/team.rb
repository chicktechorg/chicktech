class Team < ActiveRecord::Base
  validates :name, presence: true
  has_many :comments, :as => :commentable
  has_many :jobs, :as => :workable
  belongs_to :event
  has_one :leadership_role, :as => :leadable, :dependent => :destroy
  has_one :leader, :through => :leadership_role, :source => :user

  after_create :create_leadership_role

  def leader
    leadership_role.user
  end

  def jobs_of_user(user)
    jobs.where(user: user)
  end

  def self.with_leaders
    select { |team| team.leader != nil }
  end

  def jobs_with_volunteers
    jobs.where.not(user_id: nil)
  end

  def jobs_without_volunteers
    jobs.where(user_id: nil)
  end

  def number_of_available_positions
    jobs_without_volunteers.count + (leader ? 0 : 1)
  end
private

  def create_leadership_role
    LeadershipRole.create(:leadable => self)
  end
end
