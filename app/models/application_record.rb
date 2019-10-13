class ApplicationRecord < ActiveRecord::Base
  extend ActiveModel::Naming
  include CanCan::ModelAdditions
  extend ArrayHelper
  
  self.abstract_class = true

  def self.count
    self.all.size
  end

  def self.scopes_chain(scopes)
    return self.all unless scopes.present?

    scopes.inject(self) do |model, scope|
      method, param = scope
      if param
        model.send(method, param)
      else
        model.send(method)
      end
    end
  end
end
