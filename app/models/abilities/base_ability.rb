module Abilities
  class BaseAbility
    include CanCan::Ability
  
    attr_reader :user
  
    def initialize(user)
      alias_action :update, :destroy, to: :modify

      @user = user
    end
  
    def user_exist?
      user.present? && user.persisted?
    end 

    def user_confirmed?
      user_exist? && user.confirmed?
    end
  end
end