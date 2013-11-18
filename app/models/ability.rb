class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      if user.role? :volunteer
        can :read, [Event, Job, User, City, Team]
        can :update, User, id: user.id
        can :manage, Task, :job => { :user_id => user.id }
        can :update, Event, :leadership_role => { :user_id => user.id }
        can :manage, Team, :event => { :leadership_role => { :user_id => user.id } }
        can :manage, Job, :workable => { :leadership_role => { :user_id => user.id } }
        can :update, Job, :user => user
        can :update, Job, :user => nil
        can :update, Team, :leadership_role => { :user_id => user.id }
        can :update, LeadershipRole, :user => user
        can :update, LeadershipRole, :user => nil
        can :manage, Comment, :user_id => user.id
      end

      if user.role? :admin
        can :manage, [Event, Job, Task, City, LeadershipRole, Comment]
      end

      if user.role? :superadmin
        can :manage, :all
      end
    end
  end
end
