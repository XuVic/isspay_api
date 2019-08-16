class ApplicationRecord < ActiveRecord::Base
  extend ActiveModel::Naming
  include CanCan::ModelAdditions
  
  self.abstract_class = true

  def self.count
    self.all.size
  end
end
