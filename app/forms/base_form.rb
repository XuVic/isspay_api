class BaseForm
  include ActiveModel::Validations
  attr_reader :resource

  def initialize(resource)
    @resource = resource
  end

  def submit
    if valid?
      resource.save

      return resource if resource.persisted?
    else
      errors
    end
  end

  # def context
  #   resource.persisted? ? :save : :update 
  # end
end