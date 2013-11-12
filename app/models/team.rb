class Team < ActiveRecord::Base
  validates :name, presence: true

  has_many :jobs, :as => :workable
  belongs_to :event
  has_one :leadership_role, :as => :leadable

  after_create :create_leadership_role

  def leader
    leadership_role.user
  end

private

  def create_leadership_role
    LeadershipRole.create(:leadable => self)
  end
end
