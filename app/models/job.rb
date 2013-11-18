class Job < ActiveRecord::Base
  belongs_to :workable, polymorphic: true
  belongs_to :user
  has_many :tasks
  has_many :comments, :as => :commentable
  validates_presence_of :name

  def owned_by?(user)
    self.user_id == user.id
  end

  def completed_tasks
    tasks.where(done: true)
  end

  def incompleted_tasks
    tasks.where(done: false)
  end

  def taken?
    self.user_id != nil
  end
end
