class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new
    if user.admin?
      can :manage, :all
    end
    if user.customer?
      can :manage, Ride, :user_id => user.id
      can :create,User
      can :update,User,:id => user.id
    end

  end
end
