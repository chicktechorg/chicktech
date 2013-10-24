class Job < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  has_many :tasks
  has_many :comments, :as => :commentable
  validates_presence_of :name
  validates_presence_of :event_id

  def owned_by?(user)
    self.user_id == user.id
  end

  def completed_tasks
    tasks.complete
  end

  def incompleted_tasks
    tasks.incomplete
  end

  def taken?
    self.user_id != nil
  end
end
