module Abilities
  class ProductAbility < BaseAbility  
    def initialize(user)
      super(user)
  
      if user_exist? && user_confirmed?
        can :index, resource
      end

      if user.admin? && user_confirmed?
        can :modify, resource
        can :create, resource
      end
    end
  
    def resource
      Product
    end
  end
end
