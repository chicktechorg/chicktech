class LeadershipRole < ActiveRecord::Base

  belongs_to :user
  belongs_to :leadable, :polymorphic => true
  validates :name, presence: true

  after_initialize(:set_default_name, on: :create)

  def available?
    user.nil?
  end

  def set_default_name
    self.name = 'Leader'
  end

  def owned_by?(user)
    self.user_id == user.id
  end

  def get_event
    leadable.instance_of?(Event) ? leadable : leadable.event
  end
end
