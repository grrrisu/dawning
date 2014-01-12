class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.admin?
      can :manage, :all
    elsif !user.new_record? # logged in user
      # user
      can :read, User
      can :update, User, id: user.id
      # levels
      can :read, Level
    else # guest
      # user
      can [:read, :create], User
    end

  end
end
