class Team < ActiveRecord::Base
  validates :name, presence: true

  has_many :jobs, :as => :workable
  belongs_to :event
  belongs_to :leadership_role

  def leader
    leadership_role.user
  end
end
