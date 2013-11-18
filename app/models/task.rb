class Task < ActiveRecord::Base
  belongs_to :job
  validates_presence_of :description
  after_initialize :set_not_done
  
private

  def set_not_done
    self.done ||= false
  end
end
