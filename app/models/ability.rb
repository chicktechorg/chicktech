class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      if user.role? :volunteer
        can :read, [Event, Job, User, City, Team]
        can :manage, Task, :job => { :user_id => user.id }
        can :update, Event, :leadership_role => { :user_id => user.id }
        can :manage, Team, :event => { :leadership_role => { :user_id => user.id } }
        can :manage, Job, :workable => { :leadership_role => { :user_id => user.id } }
        can :update, Team, :leadership_role => { :user_id => user.id }
        can :destroy, LeadershipRole, :user => user
      end
      if user.role? :admin
        can :manage, [Event, Job, Task, City, LeadershipRole]
      end
      if user.role? :superadmin
        can :manage, :all
      end
    end
  end
end
