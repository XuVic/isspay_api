module Abilities
  class Ability < BaseAbility
    def initialize(user)
      self.merge Abilities::ProductAbility.new(user)
    end
  end
end