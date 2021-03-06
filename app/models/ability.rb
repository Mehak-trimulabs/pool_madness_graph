class Ability
  include CanCan::Ability

  def initialize(user = nil)
    user ||= User.new # guest user (not logged in)

    can :manage, :all if user.admin?

    if user.persisted?
      can :manage, User, id: user.id
      can :read, Tournament

      user.pool_users.includes(:pool).each do |pool_user|
        pool = pool_user.pool

        if pool_user.admin?
          can :manage, Pool, id: pool.id
          can :read, User, pool_users: { pool_id: pool.id }

          if pool.started?
            can :destroy, Bracket, pool_id: pool.id
          else
            can :manage, Bracket, pool_id: pool.id
          end
        else
          can :read, Pool, id: pool.id
        end

        if pool.started?
          can :read, Bracket, pool_id: pool.id
        else
          can :manage, Bracket, pool_id: pool.id, user_id: user.id
        end
      end
    end
  end
end
