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
    tasks.where(done: true)
  end

  def incompleted_tasks
    tasks.where(done: false)
  end

  def taken?
    self.user_id != nil
  end

  def change_status
    self.done = !self.done
  end

  def self.with_volunteers
    select { |job| job.taken? != false }
  end

  def get_event
    workable.instance_of?(Event) ? workable : workable.event
  end

private

  def set_not_done
    self.done ||= false
  end
end
