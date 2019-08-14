module Abilities
  class TransactionAbility < BaseAbility  
    def initialize(user)
      super(user)
  
      if user_exist?
        can :index, resource
        can :modify, resource, account_id: @user.account.id
      end
    end
  
    def resource
      Transaction
    end
  end
end
