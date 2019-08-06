class ApplicationRecord < ActiveRecord::Base
  extend ActiveModel::Naming
  self.abstract_class = true
end
