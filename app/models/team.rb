class Team < ActiveRecord::Base
  validates :name, presence: true

  has_many :jobs, :as => :workable
  belongs_to :event
end
