class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      if user.role? :volunteer
        can :read, [Event, Job, User, City, Comment]
        can :update, Job 
        can :manage, Task, :job => { :user_id => user.id }
        can :manage, Comment, :user_id => user.id
      end
      if user.role? :admin
        can :manage, [Event, Job, Task, City, Comment]
      end
      if user.role? :superadmin
        can :manage, :all
      end
    end
  end
end
