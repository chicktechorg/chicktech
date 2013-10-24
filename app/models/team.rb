class Team < ActiveRecord::Base
  validates :name, presence: true

  has_many :jobs, :as => :workable
  belongs_to :event
  has_one :leadership_role, :as => :leadable

  def leader
    leadership_role.user
  end
end
