module Abilities
  class Ability < BaseAbility
    def initialize(user)
      self.merge Abilities::ProductAbility.new(user)
      self.merge Abilities::TransactionAbility.new(user)
    end
  end
end