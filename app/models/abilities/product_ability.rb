module Abilities
  class ProductAbility < BaseAbility  
    def initialize(user)
      super(user)
  
      if user_exist?
        can :index, resource
      end

      if user.admin?
        can :modify, resource
        can :create, resource
      end
    end
  
    def resource
      Product
    end
  end
end
