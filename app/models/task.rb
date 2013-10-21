class Task < ActiveRecord::Base
  belongs_to :job
  validates_presence_of :description
  after_initialize :set_not_done

  def self.complete
    Task.where(:done => true)
  end

  def self.incomplete
    Task.where(:done => false)
  end
  
private

  def set_not_done
    self.done ||= false
  end
end
