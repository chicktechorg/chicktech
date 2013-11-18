class Job < ActiveRecord::Base
  belongs_to :workable, polymorphic: true
  belongs_to :user
  has_many :tasks
  has_many :comments, :as => :commentable
  validates_presence_of :name
  after_initialize :set_not_done

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

  def self.complete
    Job.where(:done => true)
  end

  def self.incomplete
    Job.where(:done => false)
  end
  
private

  def set_not_done
    self.done ||= false
  end
end
