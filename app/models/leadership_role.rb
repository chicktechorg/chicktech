class LeadershipRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :leadable, :polymorphic => true

  def available?
    user.nil?
  end
end
