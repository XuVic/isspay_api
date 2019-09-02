module Abilities
  class TransactionAbility < BaseAbility  
    def initialize(user)
      super(user)
  
      if user_exist?
        can :read, resource do |t|
          t.account_id == @user.account.id || @user.admin?
        end
        
        can :modify, resource, account_id: @user.account.id
      end
    end
  
    def resource
      Transaction
    end
  end
end
