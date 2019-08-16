module Abilities
  class AccountAbility < BaseAbility  
    def initialize(user)
      super(user)
  
      if user_exist?
        can :show, resource, owner_id: @user.id
      end
    end
  
    def resource
      Account
    end
  end
end
