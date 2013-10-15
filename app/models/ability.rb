class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role? :admin
      can :manage, Event
    end
    if user.role? :superadmin
      can :manage, :all
    end
  end
end
